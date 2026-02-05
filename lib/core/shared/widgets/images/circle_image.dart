import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class GlowCircleImage extends StatefulWidget {
  final String image;
  final double size;
  final Color? glowColor;
  final double borderWidth;

  // 🆕 Animation options
  final bool animateOnLoad;
  final bool hoverEffect;
  final bool pulseGlow;

  const GlowCircleImage({
    super.key,
    required this.image,
    this.size = 200,
    this.glowColor,
    this.borderWidth = 4,
    this.animateOnLoad = true,
    this.hoverEffect = true,
    this.pulseGlow = true,
  });

  @override
  State<GlowCircleImage> createState() => _GlowCircleImageState();
}

class _GlowCircleImageState extends State<GlowCircleImage>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    if (widget.pulseGlow) {
      _pulseCtrl.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color baseGlow = widget.glowColor ?? AppColors.heading;

    const gradientBorder = AppColors.primaryGradient;

    Widget imageStack = Stack(
      alignment: Alignment.center,
      children: [
        // ✨ Glow خارجي
        AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (_, __) {
            final glowStrength = widget.pulseGlow
                ? 0.18 + (_pulseCtrl.value * 0.1)
                : 0.18;

            return Container(
              width: widget.size * 1.1,
              height: widget.size * 1.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: baseGlow.withOpacity(glowStrength),
                    blurRadius: 35,
                    spreadRadius: 3,
                  ),
                ],
              ),
            );
          },
        ),

        // ✨ Halo
        Container(
          width: widget.size * 1.05,
          height: widget.size * 1.05,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [baseGlow.withOpacity(0.20), Colors.transparent],
              stops: const [0.0, 1.0],
            ),
          ),
        ),

        // 🌈 Gradient Border + Image
        Container(
          width: widget.size,
          height: widget.size,
          padding: EdgeInsets.all(widget.borderWidth),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradientBorder,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: baseGlow.withOpacity(0.30),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: widget.image.startsWith('http')
                  ? Image.network(widget.image, fit: BoxFit.cover)
                  : Image.asset(widget.image, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );

    // 🖱 Hover (Web)
    if (widget.hoverEffect) {
      imageStack = MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: imageStack,
        ),
      );
    }

    // 🎬 دخول الصفحة (Fade + Slide)
    if (widget.animateOnLoad) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, v, child) {
          return Opacity(
            opacity: v,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - v)),
              child: child,
            ),
          );
        },
        child: imageStack,
      );
    }

    return imageStack;
  }
}
