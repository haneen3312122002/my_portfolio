import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';

class ProjectShowcaseStack extends StatelessWidget {
  final String coverUrl;
  final List<String> projectImageUrls; // بدنا 3 على الأقل
  final double height;

  const ProjectShowcaseStack({
    super.key,
    required this.coverUrl,
    required this.projectImageUrls,
    this.height = 260,
  });

  @override
  Widget build(BuildContext context) {
    final images = _pickUpTo3(projectImageUrls);

    // ارتفاع جزء الغلاف اللي رح ينغطي بالتلفونات
    const phonesOverlap = 70.0;

    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ===== Cover Card =====
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // الغلاف
                  Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image_outlined, size: 34),
                    ),
                  ),

                  // تدرّج بسيط فوق الغلاف عشان النصوص لاحقاً لو بدك
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

          // ===== Mask bottom area (اختياري) =====
          // هذا بيوحي إن الغلاف "مقصوص" من تحت قبل ما التلفونات تغطيه

          // ===== Phones Row (3 devices) =====
          Positioned(
            left: 0,
            right: 0,
            bottom: -30, // شوي نازل لتكون Overlap أوضح
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
                  // const SizedBox(width: 2),
                  Expanded(
                    child: _PhoneFrame(
                      imageUrl: images[1],
                      scale: 0.95,
                      tilt: 0.0,
                    ),
                  ),
                  // const SizedBox(width: 2),
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
    // لو أقل من 3، نكرر آخر واحد عشان ما نكسر UI
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
    // اختاري جهاز من الموجودين في device_frame
    // (iPhone 13 / 14 / ... حسب ما بتحبي)
    final device = Devices.ios.iPhone13;

    return Transform.rotate(
      angle: tilt,
      child: Transform.scale(
        scale: scale,
        child: AspectRatio(
          // خليها قريبة من أبعاد شاشة الهاتف
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
    // شاشة داخل الهاتف
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
