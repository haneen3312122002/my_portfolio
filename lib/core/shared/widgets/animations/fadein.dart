import 'package:flutter/material.dart';

class AppFadeIn extends StatelessWidget {
  const AppFadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.from = 0.0,
  });

  final Widget child;

  /// مدة الأنيميشن
  final Duration duration;

  /// تأخير قبل البدء (مفيد للترتيب)
  final Duration delay;

  /// منحنى الحركة
  final Curve curve;

  /// قيمة البداية للشفافية (0 = مخفي)
  final double from;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: from, end: 1),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: delay == Duration.zero
          ? child
          : FutureBuilder(
              future: Future.delayed(delay),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                return child;
              },
            ),
    );
  }
}
