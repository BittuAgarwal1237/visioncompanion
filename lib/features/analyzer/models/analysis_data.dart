import 'package:equatable/equatable.dart';

class AnalysisTag extends Equatable {
  const AnalysisTag({required this.name, required this.confidence});

  final String name;
  final int confidence;

  @override
  List<Object?> get props => [name, confidence];
}

class AnalysisData extends Equatable {
  const AnalysisData({required this.description, required this.tags});

  final String description;
  final List<AnalysisTag> tags;

  String get summary {
    final names = tags.take(5).map((t) => t.name).join(', ');
    return names.isEmpty ? description : '$description\n$names';
  }

  @override
  List<Object?> get props => [description, tags];
}
