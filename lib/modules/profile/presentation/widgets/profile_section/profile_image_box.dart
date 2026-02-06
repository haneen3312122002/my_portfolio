import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/widgets/images/circle_image.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/profile/image_upload_viewmodel.dart';

class ProfileImageBlock extends ConsumerWidget {
  const ProfileImageBlock({super.key, required this.image, required this.size});

  final String image;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = ref.watch(isEditProvider);
    final uploader = ref.read(profileImageUploadProvider.notifier);

    return Stack(
      alignment: Alignment.center,
      children: [
        GlowCircleImage(image: image, size: size),
        if (isEdit)
          Positioned(
            right: 8,
            bottom: 8,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: uploader.pickAndUploadProfileImage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.85),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryPurple,
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 18,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
