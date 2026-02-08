import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.size = 34,
    this.borderRadius = 10,
    this.fit = BoxFit.cover,
    this.placeholderIcon = Icons.image_not_supported,
    this.backgroundColor = Colors.white10,
  });

  final String url;
  final double size;
  final double borderRadius;
  final BoxFit fit;
  final IconData placeholderIcon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: url.isEmpty
            ? Container(
                color: backgroundColor,
                child: Icon(placeholderIcon, size: size * 0.5),
              )
            : Image.network(url, fit: fit, gaplessPlayback: true),
      ),
    );
  }
}
