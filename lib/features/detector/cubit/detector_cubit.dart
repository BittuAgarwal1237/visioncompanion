import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visioncompanion/core/constants/app_constants.dart';
import 'package:visioncompanion/core/services/analytics_service.dart';
import 'package:visioncompanion/features/detector/cubit/detector_state.dart';
import 'package:visioncompanion/features/detector/data/detector_service.dart';
import 'package:visioncompanion/features/detector/models/detection.dart';
import 'package:visioncompanion/features/detector/models/object_names.dart';
import 'package:visioncompanion/features/history/data/history_repository.dart';
import 'package:visioncompanion/features/history/models/feature_type.dart';
import 'package:visioncompanion/features/settings/cubit/locale_cubit.dart';
import 'package:visioncompanion/l10n/app_localizations.dart';

class DetectorCubit extends Cubit<DetectorState> {
  DetectorCubit({
    required DetectorService service,
    required HistoryRepository history,
    required AnalyticsService analytics,
    required LocaleCubit locale,
  })  : _service = service,
        _history = history,
        _analytics = analytics,
        _locale = locale,
        super(const DetectorIdle());

  final DetectorService _service;
  final HistoryRepository _history;
  final AnalyticsService _analytics;
  final LocaleCubit _locale;

  CameraController? _camera;
  int _rotation = 0;
  bool _paused = false;
  bool _busy = false;
  String? _lastTop;
  List<Detection> _lastItems = const [];

  DateTime _lastAnnounce = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastHaptic = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastSaved = DateTime.fromMillisecondsSinceEpoch(0);

  CameraController? get camera => _camera;

  Future<void> start() async {
    await _releaseCamera();
    _paused = false;
    _busy = false;
    _lastTop = null;
    _lastItems = const [];
    emit(const DetectorIdle());
    _analytics.featureOpened(FeatureType.detector.name);

    try {
      await _service.start();

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _fail(DetectorIssue.cameraFailed);
        return;
      }
      final lens = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        lens,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      _camera = controller;
      await controller.initialize();
      _rotation = lens.sensorOrientation;

      if (isClosed) return;
      emit(const DetectorRunning());
      await controller.startImageStream(_onFrame);
    } on ModelLoadException {
      _fail(DetectorIssue.modelFailed);
    } on CameraException catch (e) {
      final denied = e.code == 'CameraAccessDenied' ||
          e.code == 'CameraAccessDeniedWithoutPrompt';
      _fail(denied ? DetectorIssue.cameraDenied : DetectorIssue.cameraFailed);
    } catch (e, st) {
      debugPrint('Detector start failed: $e\n$st');
      _fail(DetectorIssue.cameraFailed);
    }
  }

  void _fail(DetectorIssue issue) {
    if (!isClosed) emit(DetectorError(issue));
  }

  Future<void> _onFrame(CameraImage image) async {
    if (_paused || _busy || isClosed) return;
    _busy = true;

    try {
      final batch = await _service.detect(image, _rotation);
      if (!isClosed && !_paused) _publish(batch);
    } catch (e, st) {
      debugPrint('Inference failed: $e\n$st');
      _paused = true;
      _fail(DetectorIssue.inferenceFailed);
    } finally {
      _busy = false;
    }
  }

  void _publish(DetectionBatch batch) {
    final items = batch.items;

    if (items.isEmpty) {
      _lastItems = const [];
      _lastTop = null;
      emit(const DetectorRunning());
      return;
    }

    _lastItems = items;
    final top = items.first;
    final now = DateTime.now();
    final changed = top.label != _lastTop;

    final announce = now.difference(_lastAnnounce) >= AppConstants.announceGap;
    if (announce) _lastAnnounce = now;

    if (changed && now.difference(_lastHaptic) >= AppConstants.hapticGap) {
      _lastHaptic = now;
      HapticFeedback.mediumImpact();
    }

    if (changed && now.difference(_lastSaved) >= AppConstants.saveGap) {
      _lastSaved = now;
      _record(items);
    }

    _lastTop = top.label;
    emit(DetectorResults(items, batch.inferenceMs, announce: announce));
  }

  void _record(List<Detection> items) {
    final l10n = lookupAppLocalizations(_locale.state);
    final summary = items
        .take(3)
        .map((d) => '${localizedObjectName(l10n, d.label)} ${d.percent}%')
        .join(', ');

    unawaited(
      _history.add(
        FeatureType.detector,
        summary,
        items: [
          for (final d in items.take(3))
            {'label': d.label, 'percent': d.percent},
        ],
      ),
    );
    _analytics.detectionCompleted(items.first.label, items.length);
  }

  Future<void> togglePause() async {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) return;

    if (_paused) {
      _paused = false;
      await camera.resumePreview();
      emit(const DetectorRunning());
    } else {
      _paused = true;
      await camera.pausePreview();
      emit(DetectorIdle(paused: true, frozen: _lastItems));
    }
  }

  Future<void> _releaseCamera() async {
    final camera = _camera;
    _camera = null;
    if (camera == null) return;

    try {
      if (camera.value.isStreamingImages) {
        await camera.stopImageStream();
      }
    } catch (_) {}
    await camera.dispose();
  }

  @override
  Future<void> close() async {
    await _releaseCamera();
    await _service.dispose();
    return super.close();
  }
}