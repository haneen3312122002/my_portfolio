import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value, // من 0 إلى 1
    this.height = 8,
    this.duration = const Duration(milliseconds: 800),
    this.backgroundColor,
    this.color,
    this.borderRadius = 999,
  });

  /// القيمة النهائية (مثلاً 0.75 = 75%)
  final double value;

  final double height;
  final Duration duration;
  final Color? backgroundColor;
  final Color? color;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: LinearProgressIndicator(
            value: v,
            minHeight: height,
            backgroundColor: backgroundColor ?? Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}
