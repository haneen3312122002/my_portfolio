import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class PhoneFrame extends StatelessWidget {
  final String imageUrl;
  final double scale;
  final double tilt;
  final Orientation orientation;

  final Gradient? borderGradient; // 👈 جديد

  const PhoneFrame({
    super.key,
    required this.imageUrl,
    required this.scale,
    required this.tilt,
    required this.orientation,
    this.borderGradient,
  });

  static const Color primaryPurple = AppColors.primaryPurple;
  static const Color primaryBlue = AppColors.primaryBlue;

  @override
  Widget build(BuildContext context) {
    final device = Devices.ios.iPhone13;

    Widget frame = DeviceFrame(
      device: device,
      isFrameVisible: true,
      orientation: orientation,
      screen: PhoneScreen(imageUrl: imageUrl),
    );

    // 🎨 If gradient provided → wrap with border
    if (borderGradient != null) {
      frame = Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: borderGradient,
        ),
        child: frame,
      );
    }

    return Transform.rotate(
      angle: tilt,
      child: Transform.scale(scale: scale, child: frame),
    );
  }
}

class PhoneScreen extends StatelessWidget {
  final String imageUrl;
  const PhoneScreen({super.key, required this.imageUrl});

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
