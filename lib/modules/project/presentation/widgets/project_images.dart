import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';
import 'package:my_portfolio/core/shared/widgets/images/phone.dart';

class ProjectShowcaseStack extends StatelessWidget {
  final String coverUrl;
  final List<String> projectImageUrls;

  /// Height of the cover area only.
  final double coverHeight;

  /// Extra space below the cover so the phones can “hang” without being clipped.
  final double extraBottom;

  /// How much the phones visually overlap on top of the cover.
  final double overlapOnCover;

  const ProjectShowcaseStack({
    super.key,
    required this.coverUrl,
    required this.projectImageUrls,
    this.coverHeight = 240,
    this.extraBottom = 70,
    this.overlapOnCover = 70,
  });

  @override
  Widget build(BuildContext context) {
    final images = _pickUpTo3(projectImageUrls);

    // Total widget height = cover area + extra room for the phones.
    final totalHeight = coverHeight + extraBottom;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover image (background)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: coverHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image_outlined, size: 34),
                    ),
                  ),
                  // Soft gradient to improve contrast over the cover.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x66000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Phones row (foreground)
          Positioned(
            left: 0,
            right: 0,
            // You can tune this to control how much they sit on the cover.
            top: coverHeight - overlapOnCover,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PhoneFrame(
                      imageUrl: images[0],
                      scale: 0.85,
                      tilt: -0.25,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PhoneFrame(
                      imageUrl: images[1],
                      scale: 0.95,
                      tilt: 0.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PhoneFrame(
                      imageUrl: images[2],
                      scale: 0.85,
                      tilt: 0.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Ensures we always have 3 images to display (even if list is short).
  List<String> _pickUpTo3(List<String> urls) {
    if (urls.isEmpty) return ['', '', ''];
    if (urls.length == 1) return [urls[0], urls[0], urls[0]];
    if (urls.length == 2) return [urls[0], urls[1], urls[1]];
    return urls.take(3).toList();
  }
}
