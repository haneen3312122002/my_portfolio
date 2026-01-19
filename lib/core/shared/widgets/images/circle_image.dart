import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class GlowCircleImage extends StatelessWidget {
  final ImageProvider image;
  final double size;
  final Color glowColor;
  final double borderWidth;

  const GlowCircleImage({
    super.key,
    required this.image,
    this.size = 200,
    this.glowColor = const Color(0xFFB9FF6A),
    this.borderWidth = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // glow
        Container(
          width: size * 1.7,
          height: size * 1.7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.disabled,
                AppColors.heading,

                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // image container
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(borderWidth),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: ClipOval(
            child: Image(image: image, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
