import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/widgets/images/circle_image.dart';
import 'package:my_portfolio/core/shared/widgets/texts/title_text.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/image_upload_viewmodel.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/profile_viewmodle.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/edit/about_me_card_edit.dart';

class ProfileSection extends ConsumerWidget {
  final ProfileEntity profile;

  const ProfileSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = ref.watch(isEditProvider);

    return SizedBox(
      width: 360,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),

          // ===== IMAGE + UPLOAD ICON =====
          Stack(
            alignment: Alignment.center,
            children: [
              GlowCircleImage(image: profile.image, size: 280),

              if (isEdit)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Material(
                    color: Colors.black.withOpacity(0.6),
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Change profile image',
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        ref
                            .read(profileImageUploadProvider.notifier)
                            .pickAndUploadProfileImage();
                      },
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // ===== NAME =====
          isEdit
              ? TextFormField(
                  initialValue: profile.name.isEmpty ? '' : profile.name,
                  decoration: const InputDecoration(
                    hintText: 'Type your name...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    final draft = {...ref.read(profileDraftProvider)};
                    draft['name'] = v.trim();
                    ref.read(profileDraftProvider.notifier).state = draft;
                  },
                )
              : Center(
                  child: AppTitle(profile.name, textAlign: TextAlign.center),
                ),
        ],
      ),
    );
  }
}
