import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/constants/images/images_paths.dart';
import 'package:my_portfolio/core/shared/widgets/common/scaffold.dart';
import 'package:my_portfolio/core/shared/widgets/images/circle_image.dart';
import 'package:my_portfolio/core/shared/widgets/texts/title_text.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/about_me_card.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/profile_section.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/social_skills_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double? size = 44;
    return AppScaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= LEFT SECTION =================
                  ProfileSection(),
                  const SizedBox(width: 48),

                  // ================= RIGHT SECTION =================
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -------- ABOUT CARD --------
                        AboutMeCard(),

                        const SizedBox(height: 32),

                        // -------- SKILLS / SOCIAL --------
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [SocialSection()],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
