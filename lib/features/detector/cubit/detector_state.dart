import 'package:equatable/equatable.dart';
import 'package:visioncompanion/features/detector/models/detection.dart';

enum DetectorIssue { cameraDenied, cameraFailed, modelFailed, inferenceFailed }

sealed class DetectorState extends Equatable {
  const DetectorState();

  @override
  List<Object?> get props => const [];
}

class DetectorIdle extends DetectorState {
  const DetectorIdle({this.paused = false, this.frozen = const []});

  final bool paused;
  final List<Detection> frozen;

  @override
  List<Object?> get props => [paused, frozen];
}

class DetectorRunning extends DetectorState {
  const DetectorRunning();
}

class DetectorResults extends DetectorState {
  const DetectorResults(
    this.detections,
    this.inferenceMs, {
    this.announce = false,
  });

  final List<Detection> detections;
  final int inferenceMs;
  final bool announce;

  @override
  List<Object?> get props => [detections, inferenceMs, announce];
}

class DetectorError extends DetectorState {
  const DetectorError(this.issue);

  final DetectorIssue issue;

  @override
  List<Object?> get props => [issue];
}
