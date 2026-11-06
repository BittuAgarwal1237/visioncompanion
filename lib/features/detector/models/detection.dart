import 'dart:ui';

import 'package:equatable/equatable.dart';

class Detection extends Equatable {
  const Detection({
    required this.label,
    required this.confidence,
    required this.box,
  });

  final String label;
  final double confidence;
  final Rect box;

  int get percent => (confidence * 100).round();

  @override
  List<Object?> get props => [label, confidence, box];
}
