import 'package:flutter/material.dart';

class SocialSection extends StatelessWidget {
  const SocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    double? size = 44; // This variable is not used to rebuild the widget.
    // The onHover logic is not reactive.
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.flutter_dash_outlined, size: 44),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.facebook, size: 44),
        ),
        IconButton(
          onHover: (value) => size = 90,
          onPressed: () {},
          icon: const Icon(Icons.email, size: 44),
        ),
      ],
    );
  }
}
