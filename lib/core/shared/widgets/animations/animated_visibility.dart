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
    this.replay = true,
    this.protectFocus = true,
    this.protectKeyboard = true,
    this.onReplay,
  });

  final Widget child;
  final Duration duration;
  final double offsetY;
  final Curve curve;
  final double visibleFraction;
  final Duration cooldown;

  final bool replay;
  final bool protectFocus;
  final bool protectKeyboard;

  final VoidCallback? onReplay;

  @override
  State<AnimateOnVisible> createState() => _AnimateOnVisibleState();
}

class _AnimateOnVisibleState extends State<AnimateOnVisible>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  final FocusScopeNode _scopeNode = FocusScopeNode(
    debugLabel: 'AnimateOnVisible',
  );

  // ✅ أهم سطر: key ثابت ما بيتغير مع rebuild
  final Key _vdKey = UniqueKey();

  bool _cooling = false;
  Timer? _timer;
  bool _playedOnce = false;

  @override
  void initState() {
    super.initState();

    _c = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _c, curve: widget.curve);
    _slide = Tween<double>(
      begin: widget.offsetY,
      end: 0,
    ).animate(CurvedAnimation(parent: _c, curve: widget.curve));

    _c.value = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    _scopeNode.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _cooling = true;
    _timer?.cancel();
    _timer = Timer(widget.cooldown, () => _cooling = false);
  }

  void _playFromStart() {
    _c.stop();
    _c.reset();
    _c.forward();
  }

  bool get _hasFocusInside => widget.protectFocus && _scopeNode.hasFocus;

  bool _keyboardVisible(BuildContext context) {
    if (!widget.protectKeyboard) return false;
    return MediaQuery.viewInsetsOf(context).bottom > 0;
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _scopeNode,
      child: VisibilityDetector(
        key: _vdKey, // ✅ ثابت
        onVisibilityChanged: (info) {
          final f = info.visibleFraction;

          // ✅ إذا الكيبورد ظاهر أو في فوكس جوّا: لا تسوي أي reset/replay
          if (_keyboardVisible(context)) return;
          if (_hasFocusInside) return;

          // ✅ replay=false: شغله مرة وحدة وخلاص
          if (!widget.replay) {
            if (!_playedOnce && f >= widget.visibleFraction) {
              _playedOnce = true;
              _c.forward();
              widget.onReplay?.call();
            }
            return;
          }

          // ✅ replay=true: يرجع يخفي نفسه فقط إذا طلع فعلاً من الشاشة
          if (f <= 0.02) {
            _c.stop();
            _c.reset();
            return;
          }

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
              opacity: _fade.value,
              child: Transform.translate(
                offset: Offset(0, _slide.value),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
