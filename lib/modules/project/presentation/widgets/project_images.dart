import 'package:flutter/material.dart';
import 'package:my_portfolio/core/shared/widgets/images/phone.dart';
import 'package:my_portfolio/core/shared/widgets/images/square_image.dart';

class ProjectShowcaseStack extends StatelessWidget {
  final String coverUrl;
  final List<String> projectImageUrls;

  /// Height of the cover area only.
  final double coverHeight;

  /// Extra space below the cover so the phones can “hang” without being clipped.
  final double extraBottom;

  /// How much the phones visually overlap on top of the cover.
  final double overlapOnCover;

  /// If true => portrait phones (stacked)
  /// If false => landscape devices (stacked)
  final bool isVertical;

  const ProjectShowcaseStack({
    super.key,
    required this.coverUrl,
    required this.projectImageUrls,
    this.coverHeight = 240,
    this.extraBottom = 70,
    this.overlapOnCover = 70,
    this.isVertical = true,
  });

  @override
  Widget build(BuildContext context) {
    final images = _pickUpTo3(projectImageUrls);

    final totalHeight = coverHeight + extraBottom;

    // Use overlapOnCover to decide where the devices should start.
    final top = isVertical ? 40.0 : coverHeight - overlapOnCover;
    final phonesHeight = totalHeight - top;

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
                  AppImage(
                    url: coverUrl,
                    borderRadius: 18,
                    fit: BoxFit.cover,
                    neonBorder: true,
                  ),
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

          // Devices (foreground)
          Positioned(
            left: 0,
            right: 0,
            top: top,
            height: phonesHeight, // prevents "no size" hit-test issues
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: isVertical
                  ? _PortraitRow(images: images)
                  : _LandscapeGrid(images: images),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _pickUpTo3(List<String> urls) {
    if (urls.isEmpty) return ['', '', ''];
    if (urls.length == 1) return [urls[0], urls[0], urls[0]];
    if (urls.length == 2) return [urls[0], urls[1], urls[1]];
    return urls.take(3).toList();
  }
}

// ===== Portrait layout (smaller, light overlap) =====
// ===== Portrait layout =====
// Center on top + left/right behind with slight edge overlap
class _PortraitRow extends StatelessWidget {
  final List<String> images;
  const _PortraitRow({required this.images});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final w = c.maxWidth;

        // Smaller devices
        final cardW = (w * 0.24).clamp(90.0, 150.0);

        // More spacing (less overlap)
        final dx = (cardW * 0.75).clamp(75.0, 150.0);

        final h = (cardW * 1.8).clamp(170.0, 260.0);

        return SizedBox(
          height: h,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // Left (behind) - Purple ONLY
              Positioned(
                left: (w / 2) - (cardW / 2) - dx,
                top: 16,
                width: cardW,
                child: PhoneFrame(
                  imageUrl: images[0],
                  scale: 0.85,
                  tilt: -0.10,
                  orientation: Orientation.portrait,
                  borderGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      PhoneFrame.primaryPurple,
                      PhoneFrame.primaryPurple,
                    ],
                  ),
                ),
              ),

              // Right (behind) - Blue ONLY
              Positioned(
                left: (w / 2) - (cardW / 2) + dx,
                top: 16,
                width: cardW,
                child: PhoneFrame(
                  imageUrl: images[2],
                  scale: 0.85,
                  tilt: 0.10,
                  orientation: Orientation.portrait,
                  borderGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [PhoneFrame.primaryBlue, PhoneFrame.primaryBlue],
                  ),
                ),
              ),

              // Center (front) - Gradient ONLY here
              Positioned(
                left: (w / 2) - (cardW / 2),
                top: 0,
                width: cardW,
                child: PhoneFrame(
                  imageUrl: images[1],
                  scale: 0.92,
                  tilt: 0.0,
                  orientation: Orientation.portrait,
                  borderGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [PhoneFrame.primaryPurple, PhoneFrame.primaryBlue],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ===== Landscape layout =====
class _LandscapeGrid extends StatelessWidget {
  final List<String> images;
  const _LandscapeGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final w = c.maxWidth;

        final cardW = (w * 0.40).clamp(140.0, 240.0);
        final dx = (cardW * 0.82).clamp(95.0, 180.0);
        final h = (cardW * 0.72).clamp(120.0, 190.0);

        return SizedBox(
          height: h,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Left (behind) - Purple ONLY
              Positioned(
                left: (w / 2) - (cardW / 2) - dx,
                top: 10,
                width: cardW,
                child: PhoneFrame(
                  imageUrl: images[0],
                  scale: 0.92,
                  tilt: -0.06,
                  orientation: Orientation.landscape,
                  borderGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      PhoneFrame.primaryPurple,
                      PhoneFrame.primaryPurple,
                    ],
                  ),
                ),
              ),

              // Right (behind) - Blue ONLY
              Positioned(
                left: (w / 2) - (cardW / 2) + dx,
                top: 10,
                width: cardW,
                child: PhoneFrame(
                  imageUrl: images[2],
                  scale: 0.92,
                  tilt: 0.06,
                  orientation: Orientation.landscape,
                  borderGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [PhoneFrame.primaryBlue, PhoneFrame.primaryBlue],
                  ),
                ),
              ),

              // Center (front) - Gradient ONLY here
              Positioned(
                left: (w / 2) - (cardW / 2),
                top: 0,
                width: cardW,
                child: PhoneFrame(
                  imageUrl: images[1],
                  scale: 0.98,
                  tilt: 0.0,
                  orientation: Orientation.landscape,
                  borderGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [PhoneFrame.primaryPurple, PhoneFrame.primaryBlue],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
