import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatefulWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value, // 0..1
    required this.color,
    this.height = 8,
    this.duration = const Duration(milliseconds: 2200),
    this.backgroundColor,
    this.borderRadius = 999,
    this.replayKey,
    this.curve = Curves.easeInOutCubic,
  });

  final double value;
  final Color color;
  final double height;
  final Duration duration;
  final Color? backgroundColor;
  final double borderRadius;
  final Object? replayKey;
  final Curve curve;

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ).drive(Tween<double>(begin: 0.0, end: widget.value.clamp(0, 1)));

    // 🔥 هذا هو السطر السحري
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.replayKey != widget.replayKey ||
        oldWidget.value != widget.value) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;

        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            height: widget.height,
            color: widget.backgroundColor ?? Colors.grey.withValues(alpha: 0.2),
            alignment: Alignment.centerLeft,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                return Container(
                  height: widget.height,
                  width: fullWidth * _animation.value, // ✅ التمدّد الحقيقي
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
