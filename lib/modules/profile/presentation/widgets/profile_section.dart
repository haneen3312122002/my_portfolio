import 'package:flutter/material.dart';
import 'package:my_portfolio/core/shared/constants/images/images_paths.dart';
import 'package:my_portfolio/core/shared/widgets/images/circle_image.dart';
import 'package:my_portfolio/core/shared/widgets/texts/title_text.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(height: 12),
          GlowCircleImage(
            image: AppImages.backgroundImage,
            size: 280,
          ),
          SizedBox(height: 20),
          AppTitle('Haneen Khanfar'),
        ],
      ),
    );
  }
}
