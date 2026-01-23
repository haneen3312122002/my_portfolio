import 'package:flutter/material.dart';

class SlideFadeSwitcher extends StatelessWidget {
  const SlideFadeSwitcher({
    super.key,
    required this.child,
    required this.switchKey,
    this.duration = const Duration(milliseconds: 300),
    this.offset = const Offset(0.12, 0),
    this.curveIn = Curves.easeOut,
    this.curveOut = Curves.easeIn,
  });

  /// الويجت اللي راح يتبدّل
  final Widget child;

  /// لازم يتغير مع تغيّر المحتوى
  final Key switchKey;

  /// مدة الأنيميشن
  final Duration duration;

  /// اتجاه الدخول (افتراضي: من اليمين)
  final Offset offset;

  /// منحنى الدخول
  final Curve curveIn;

  /// منحنى الخروج
  final Curve curveOut;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curveIn,
      switchOutCurve: curveOut,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: offset,
          end: Offset.zero,
        ).animate(animation);

        final fade = Tween<double>(begin: 0, end: 1).animate(animation);

        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: fade, child: child),
        );
      },
      child: KeyedSubtree(key: switchKey, child: child),
    );
  }
}
