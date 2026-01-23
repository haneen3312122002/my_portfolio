import 'package:flutter/material.dart';

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
    final p = path.trim();
    if (p.startsWith('http')) {
      return NetworkImage(p);
    }
    return AssetImage(p);
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = image.trim().isNotEmpty;

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
            child: image.trim().startsWith('http')
                ? Image.network(
                    image.trim(),
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    errorBuilder: (_, e, __) =>
                        Center(child: Text('Image error: $e')),
                  )
                : Image.asset(image.trim(), fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
