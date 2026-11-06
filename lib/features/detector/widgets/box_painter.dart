import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:visioncompanion/features/detector/models/detection.dart';
import 'package:visioncompanion/features/detector/models/object_category.dart';

class BoxPainter extends CustomPainter {
  BoxPainter(this.detections, this.nameOf);

  final List<Detection> detections;
  final String Function(String label) nameOf;

  @override
  void paint(Canvas canvas, Size size) {
    for (final detection in detections) {
      final color = ObjectCategory.of(detection.label).color;
      final box = detection.box;
      final rect = Rect.fromLTRB(
        box.left * size.width,
        box.top * size.height,
        box.right * size.width,
        box.bottom * size.height,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );

      final text = TextPainter(
        text: TextSpan(
          text: '${nameOf(detection.label)} ${detection.percent}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: math.max(40, size.width - rect.left - 12));

      final tag = Rect.fromLTWH(
        rect.left,
        math.max(0, rect.top - text.height - 8),
        text.width + 14,
        text.height + 8,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(tag, const Radius.circular(8)),
        Paint()..color = color,
      );
      text.paint(canvas, Offset(tag.left + 7, tag.top + 4));
    }
  }

  @override
  bool shouldRepaint(BoxPainter oldDelegate) {
    return oldDelegate.detections != detections;
  }
}
