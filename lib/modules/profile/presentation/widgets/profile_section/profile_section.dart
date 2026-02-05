import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/app/layouts/layouts_enum.dart';
import 'package:my_portfolio/core/app/layouts/responsive_layout.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/profile_section/profile_image_box.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/profile_section/profile_text_content.dart';

class ProfileSection extends ConsumerWidget {
  final ProfileEntity profile;
  const ProfileSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: AppResponsiveShell(
          builder: (context, screen) {
            final isDesktop = screen == AppScreenType.desktop;

            return isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: ProfileTextContent(
                          profile: profile,
                          centered: false,
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 4,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ProfileImageBlock(
                            image: profile.image,
                            size: 380,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileImageBlock(
                        image: profile.image,
                        size: screen == AppScreenType.mobile ? 260 : 380,
                      ),
                      const SizedBox(height: 24),
                      ProfileTextContent(profile: profile, centered: true),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
