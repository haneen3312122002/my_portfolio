import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.size,
    this.borderRadius = 10,
    this.fit = BoxFit.cover,
    this.placeholderIcon = Icons.image_not_supported,
    this.backgroundColor = Colors.white10,
    this.neonBorder = false,
  });

  final String url;
  final double? size;
  final double borderRadius;
  final BoxFit fit;
  final IconData placeholderIcon;
  final Color backgroundColor;
  final bool neonBorder;

  static const Color primaryPurple = Color.fromARGB(255, 124, 122, 255);

  static const Color primaryBlue = Color.fromARGB(255, 184, 31, 255);

  @override
  Widget build(BuildContext context) {
    final imageChild = url.isEmpty
        ? Container(
            color: backgroundColor,
            alignment: Alignment.center,
            child: Icon(placeholderIcon),
          )
        : Image.network(url, fit: fit, gaplessPlayback: true);

    // الصورة الداخلية
    final clipped = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius - (neonBorder ? 3 : 0)),
      child: size != null
          ? SizedBox(width: size, height: size, child: imageChild)
          : imageChild,
    );

    if (!neonBorder) return clipped;

    // بوردر قطري واضح بدون blur
    return Container(
      padding: const EdgeInsets.all(3), // سماكة البوردر
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryPurple, primaryBlue],
        ),
      ),
      child: clipped,
    );
  }
}
