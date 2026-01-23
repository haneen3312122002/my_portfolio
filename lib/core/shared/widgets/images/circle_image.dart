import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class GlowCircleImage extends StatelessWidget {
  final String image; // asset أو url
  final double size;
  final Color glowColor;
  final double borderWidth;

  const GlowCircleImage({
    super.key,
    required this.image,
    this.size = 500,
    this.glowColor = const Color(0xFFB9FF6A),
    this.borderWidth = 6,
  });

  ImageProvider _resolveImage(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // glow
        Container(
          width: size * 1.4,
          height: size * 1.4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                glowColor.withOpacity(0.6),
                glowColor.withOpacity(0.25),
                Colors.transparent,
              ],
              stops: const [0.0, 0.6, 1.0],
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
            child: Image(image: _resolveImage(image), fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
