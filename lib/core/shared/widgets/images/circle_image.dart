import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class GlowCircleImage extends StatelessWidget {
  final String image;
  final double size;
  final Color? glowColor; // اختياري
  final double borderWidth;

  const GlowCircleImage({
    super.key,
    required this.image,
    this.size = 200,
    this.glowColor,
    this.borderWidth = 5,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseGlow = glowColor ?? AppColors.heading;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 🔥 Glow خارجي قوي (Neon)
        Container(
          width: size * 1.2,
          height: size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: baseGlow.withOpacity(0.75),
                blurRadius: 90,
                spreadRadius: 25,
              ),
              BoxShadow(
                color: baseGlow.withOpacity(0.45),
                blurRadius: 150,
                spreadRadius: 45,
              ),
            ],
          ),
        ),

        // ✨ Glow ناعم قريب من الصورة
        Container(
          width: size * 1.15,
          height: size * 1.15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                baseGlow.withOpacity(0.85),
                baseGlow.withOpacity(0.35),
                Colors.transparent,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),

        // 🖼️ الصورة
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black, // يبرز النيون
            boxShadow: [
              BoxShadow(
                color: baseGlow.withOpacity(0.9),
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
          ),
          child: ClipOval(
            child: image.startsWith('http')
                ? Image.network(image, fit: BoxFit.cover)
                : Image.asset(image, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
