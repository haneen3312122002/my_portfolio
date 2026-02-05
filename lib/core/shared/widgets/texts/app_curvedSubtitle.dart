import 'dart:math' as math;
import 'package:flutter/material.dart';

class SoftArchText extends StatelessWidget {
  const SoftArchText(
    this.text, {
    super.key,
    this.curve = 0.08, // 👈 كل ما قل الرقم = أخف
    this.style,
  });

  final String text;
  final double curve;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(-curve),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: style ?? Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
