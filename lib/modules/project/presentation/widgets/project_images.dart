import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';

class ProjectShowcaseStack extends StatelessWidget {
  final String coverUrl;
  final List<String> projectImageUrls;

  /// ارتفاع “منطقة الكفر” فقط
  final double coverHeight;

  /// مساحة إضافية تحت الكفر عشان التلفونات تنزل بدون قص
  final double extraBottom;

  /// قديش التلفونات تغطي من الكفر للأعلى
  final double overlapOnCover;

  const ProjectShowcaseStack({
    super.key,
    required this.coverUrl,
    required this.projectImageUrls,
    this.coverHeight = 240,
    this.extraBottom = 70, // ✅ خليها أكبر إذا بدك التلفونات تنزل أكثر
    this.overlapOnCover = 70, // ✅ قديش تغطي من الكفر
  });

  @override
  Widget build(BuildContext context) {
    final images = _pickUpTo3(projectImageUrls);

    // ✅ الارتفاع الحقيقي للودجت = كفر + مساحة لتحت
    final totalHeight = coverHeight + extraBottom;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ====== COVER فقط بارتفاع coverHeight ======
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

          // ====== PHONES: تبدأ من (coverHeight - overlapOnCover) ======
          Positioned(
            left: 0,
            right: 0,
            top: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _PhoneFrame(
                      imageUrl: images[0],
                      scale: 0.85,
                      tilt: -0.25,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PhoneFrame(
                      imageUrl: images[1],
                      scale: 0.95,
                      tilt: 0.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PhoneFrame(
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

  List<String> _pickUpTo3(List<String> urls) {
    if (urls.isEmpty) return ['', '', ''];
    if (urls.length == 1) return [urls[0], urls[0], urls[0]];
    if (urls.length == 2) return [urls[0], urls[1], urls[1]];
    return urls.take(3).toList();
  }
}

class _PhoneFrame extends StatelessWidget {
  final String imageUrl;
  final double scale;
  final double tilt;

  const _PhoneFrame({
    required this.imageUrl,
    required this.scale,
    required this.tilt,
  });

  @override
  Widget build(BuildContext context) {
    final device = Devices.ios.iPhone13;

    return Transform.rotate(
      angle: tilt,
      child: Transform.scale(
        scale: scale,
        child: AspectRatio(
          aspectRatio: 9 / 18,
          child: DeviceFrame(
            device: device,
            isFrameVisible: true,
            orientation: Orientation.portrait,
            screen: _PhoneScreen(imageUrl: imageUrl),
          ),
        ),
      ),
    );
  }
}

class _PhoneScreen extends StatelessWidget {
  final String imageUrl;
  const _PhoneScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: imageUrl.isEmpty
          ? Container(
              color: Colors.black12,
              alignment: Alignment.center,
              child: const Icon(Icons.image_outlined),
            )
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.black12,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
    );
  }
}
