import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class PhoneFrame extends StatelessWidget {
  final String imageUrl;
  final double scale;
  final double tilt;

  const PhoneFrame({
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
            screen: PhoneScreen(imageUrl: imageUrl),
          ),
        ),
      ),
    );
  }
}

class PhoneScreen extends StatelessWidget {
  final String imageUrl;
  const PhoneScreen({required this.imageUrl});

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
