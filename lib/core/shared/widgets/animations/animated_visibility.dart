import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimateOnVisible extends StatefulWidget {
  const AnimateOnVisible({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.offsetY = 18,
    this.curve = Curves.easeOutCubic,
    this.visibleFraction = 0.35,
    this.cooldown = const Duration(milliseconds: 700),
    this.onReplay,
  });

  final Widget child;
  final Duration duration;
  final double offsetY;
  final Curve curve;
  final VoidCallback? onReplay;

  /// لازم هذا الجزء من السكشن يبان عشان نبدأ الأنيميشن
  final double visibleFraction;

  /// يمنع التكرار السريع
  final Duration cooldown;

  @override
  State<AnimateOnVisible> createState() => _AnimateOnVisibleState();
}

class _AnimateOnVisibleState extends State<AnimateOnVisible>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  bool _cooling = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _c = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _c, curve: widget.curve);
    _slide = Tween<double>(
      begin: widget.offsetY,
      end: 0,
    ).animate(CurvedAnimation(parent: _c, curve: widget.curve));

    // ✅ مهم: يبدأ مخفي
    _c.value = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _cooling = true;
    _timer?.cancel();
    _timer = Timer(widget.cooldown, () => _cooling = false);
  }

  void _playFromStart() {
    _c.stop();
    _c.reset(); // ✅ يخليه مخفي فورًا
    _c.forward();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey('vis_${widget.key ?? widget.hashCode}'),
      onVisibilityChanged: (info) {
        final f = info.visibleFraction;

        // ✅ إذا طلع تقريبًا من الشاشة: رجّعه مخفي عشان المرة الجاية يعيد
        if (f <= 0.02) {
          _c.stop();
          _c.reset();
          return;
        }

        // ✅ إذا دخل بشكل كافي: شغّل الأنيميشن من الصفر (مرة، مع cooldown)
        if (f >= widget.visibleFraction && !_cooling && _c.value == 0) {
          _playFromStart();
          widget.onReplay?.call();
          _startCooldown();
        }
      },
      child: AnimatedBuilder(
        animation: _c,
        child: widget.child,
        builder: (context, child) {
          return Opacity(
            opacity: _fade.value, // 0 بالبداية
            child: Transform.translate(
              offset: Offset(0, _slide.value),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
