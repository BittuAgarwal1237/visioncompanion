import 'package:equatable/equatable.dart';
import 'package:visioncompanion/features/analyzer/models/analysis_data.dart';

enum AnalyzerIssue {
  noInternet,
  timeout,
  busy,
  badKey,
  missingKey,
  parse,
  camera,
  unknown,
}

sealed class AnalyzerState extends Equatable {
  const AnalyzerState();

  @override
  List<Object?> get props => const [];
}

class AnalyzerIdle extends AnalyzerState {
  const AnalyzerIdle();
}

class AnalyzerProcessing extends AnalyzerState {
  const AnalyzerProcessing(this.imagePath);

  final String imagePath;

  @override
  List<Object?> get props => [imagePath];
}

class AnalyzerResult extends AnalyzerState {
  const AnalyzerResult(this.data, this.imagePath);

  final AnalysisData data;
  final String imagePath;

  @override
  List<Object?> get props => [data, imagePath];
}

class AnalyzerError extends AnalyzerState {
  const AnalyzerError(this.issue, {this.imagePath});

  final AnalyzerIssue issue;
  final String? imagePath;

  @override
  List<Object?> get props => [issue, imagePath];
}
