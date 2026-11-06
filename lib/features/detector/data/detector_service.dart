import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:visioncompanion/core/constants/app_constants.dart';
import 'package:visioncompanion/features/detector/models/detection.dart';

class ModelLoadException implements Exception {
  const ModelLoadException();
}

class DetectionBatch {
  const DetectionBatch(this.items, this.inferenceMs);

  final List<Detection> items;
  final int inferenceMs;
}

class DetectorService {
  Isolate? _isolate;
  ReceivePort? _inbox;
  SendPort? _worker;
  Completer<DetectionBatch>? _waiting;
  List<String> _labels = const [];

  Future<void> start() async {
    if (_worker != null) return;

    final modelBytes = await _readAssets();

    final inbox = ReceivePort();
    final ready = Completer<SendPort>();
    inbox.listen((message) {
      if (message is SendPort) {
        ready.complete(message);
      } else if (message is _ModelFailed) {
        if (!ready.isCompleted) ready.completeError(const ModelLoadException());
      } else if (message is _Output) {
        _deliver(message);
      } else if (message is _Failure) {
        _waiting?.completeError(StateError(message.text));
        _waiting = null;
      }
    });
    _inbox = inbox;

    _isolate = await Isolate.spawn(
      _runWorker,
      _WorkerSetup(inbox.sendPort, modelBytes),
    );

    try {
      _worker = await ready.future;
    } catch (_) {
      await dispose();
      rethrow;
    }
  }

  Future<Uint8List> _readAssets() async {
    try {
      // Model file ka naam/folder kuch bhi ho, manifest me se .tflite dhundh lo.
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assets = manifest.listAssets();
      final modelPath = assets.contains(AppConstants.modelAsset)
          ? AppConstants.modelAsset
          : assets.firstWhere(
            (a) => a.startsWith('assets/models/') && a.endsWith('.tflite'),
      );
      final labelsPath = assets.contains(AppConstants.labelsAsset)
          ? AppConstants.labelsAsset
          : assets.firstWhere(
            (a) => a.startsWith('assets/models/') && a.endsWith('.txt'),
      );
      debugPrint('Using model: $modelPath, labels: $labelsPath');

      final data = await rootBundle.load(modelPath);
      final text = await rootBundle.loadString(labelsPath);
      _labels = text.split('\n').map((line) => line.trim()).toList();
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } catch (e, st) {
      debugPrint('Model asset load failed: $e\n$st');
      throw const ModelLoadException();
    }
  }

  Future<DetectionBatch> detect(CameraImage image, int rotation) {
    final worker = _worker;
    if (worker == null || image.planes.length < 3) {
      return Future.error(StateError('detector is not ready'));
    }

    final done = Completer<DetectionBatch>();
    _waiting = done;
    worker.send(
      _FrameJob(
        width: image.width,
        height: image.height,
        rotation: rotation,
        yPlane: image.planes[0].bytes,
        uPlane: image.planes[1].bytes,
        vPlane: image.planes[2].bytes,
        yStride: image.planes[0].bytesPerRow,
        uvStride: image.planes[1].bytesPerRow,
        uvPixel: image.planes[1].bytesPerPixel ?? 1,
      ),
    );
    return done.future;
  }

  void _deliver(_Output output) {
    final values = output.values;
    final items = <Detection>[];

    for (var i = 0; i + 5 < values.length; i += 6) {
      final index = values[i].toInt() + 1;
      if (index < 0 || index >= _labels.length) continue;
      final label = _labels[index];
      if (label.isEmpty || label == '???') continue;

      items.add(
        Detection(
          label: label,
          confidence: values[i + 1],
          box: Rect.fromLTRB(
            _unit(values[i + 3]),
            _unit(values[i + 2]),
            _unit(values[i + 5]),
            _unit(values[i + 4]),
          ),
        ),
      );
    }

    items.sort((a, b) => b.confidence.compareTo(a.confidence));
    _waiting?.complete(DetectionBatch(items, output.micros ~/ 1000));
    _waiting = null;
  }

  double _unit(double value) => value < 0 ? 0 : (value > 1 ? 1 : value);

  Future<void> dispose() async {
    _worker?.send('close');
    _worker = null;
    _inbox?.close();
    _inbox = null;
    _isolate = null;
    _waiting = null;
  }
}

class _WorkerSetup {
  const _WorkerSetup(this.reply, this.model);

  final SendPort reply;
  final Uint8List model;
}

class _FrameJob {
  const _FrameJob({
    required this.width,
    required this.height,
    required this.rotation,
    required this.yPlane,
    required this.uPlane,
    required this.vPlane,
    required this.yStride,
    required this.uvStride,
    required this.uvPixel,
  });

  final int width;
  final int height;
  final int rotation;
  final Uint8List yPlane;
  final Uint8List uPlane;
  final Uint8List vPlane;
  final int yStride;
  final int uvStride;
  final int uvPixel;
}

class _Output {
  const _Output(this.values, this.micros);

  final List<double> values;
  final int micros;
}

class _Failure {
  const _Failure(this.text);

  final String text;
}

class _ModelFailed {
  const _ModelFailed();
}

void _runWorker(_WorkerSetup setup) {
  final Interpreter interpreter;
  try {
    final options = InterpreterOptions()..threads = 4;
    interpreter = Interpreter.fromBuffer(setup.model, options: options);
  } catch (e) {
    debugPrint('Interpreter init failed: $e');
    setup.reply.send(const _ModelFailed());
    return;
  }

  final inputTensor = interpreter.getInputTensor(0);
  final side = inputTensor.shape[1];
  final floatInput =
  !inputTensor.type.toString().toLowerCase().contains('uint8');
  final slots = interpreter.getOutputTensor(0).shape[1];

  final inbox = ReceivePort();
  inbox.listen((message) {
    if (message is _FrameJob) {
      try {
        final clock = Stopwatch()..start();
        final input = _toInput(message, side, floatInput);

        final boxes = List.generate(
          1,
              (_) => List.generate(slots, (_) => List<double>.filled(4, 0)),
        );
        final classes = [List<double>.filled(slots, 0)];
        final scores = [List<double>.filled(slots, 0)];
        final total = [0.0];

        interpreter.runForMultipleInputs(
          [input],
          {0: boxes, 1: classes, 2: scores, 3: total},
        );

        final values = <double>[];
        for (var i = 0; i < slots; i++) {
          final score = scores[0][i];
          if (score < AppConstants.minScore) continue;
          final b = boxes[0][i];
          values
            ..add(classes[0][i])
            ..add(score)
            ..add(b[0])
            ..add(b[1])
            ..add(b[2])
            ..add(b[3]);
        }

        setup.reply.send(_Output(values, clock.elapsedMicroseconds));
      } catch (error) {
        setup.reply.send(_Failure(error.toString()));
      }
    } else if (message == 'close') {
      interpreter.close();
      inbox.close();
    }
  });

  setup.reply.send(inbox.sendPort);
}

Uint8List _toInput(_FrameJob job, int side, bool floatInput) {
  final rgb = Uint8List(side * side * 3);
  final turned = job.rotation == 90 || job.rotation == 270;
  final uprightWidth = turned ? job.height : job.width;
  final uprightHeight = turned ? job.width : job.height;

  var cursor = 0;
  for (var y = 0; y < side; y++) {
    final uy = y * uprightHeight ~/ side;
    for (var x = 0; x < side; x++) {
      final ux = x * uprightWidth ~/ side;

      final (sx, sy) = switch (job.rotation) {
        90 => (uy, job.height - 1 - ux),
        180 => (job.width - 1 - ux, job.height - 1 - uy),
        270 => (job.width - 1 - uy, ux),
        _ => (ux, uy),
      };

      final luma = job.yPlane[sy * job.yStride + sx];
      final chroma = (sy >> 1) * job.uvStride + (sx >> 1) * job.uvPixel;
      final u = job.uPlane[chroma] - 128;
      final v = job.vPlane[chroma] - 128;

      rgb[cursor++] = _byte(luma + 1.402 * v);
      rgb[cursor++] = _byte(luma - 0.344136 * u - 0.714136 * v);
      rgb[cursor++] = _byte(luma + 1.772 * u);
    }
  }

  if (!floatInput) return rgb;

  final floats = Float32List(rgb.length);
  for (var i = 0; i < rgb.length; i++) {
    floats[i] = (rgb[i] - 127.5) / 127.5;
  }
  return floats.buffer.asUint8List();
}

int _byte(double value) {
  if (value < 0) return 0;
  if (value > 255) return 255;
  return value.toInt();
}