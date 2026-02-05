import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_portfolio/core/shared/widgets/images/circle_image.dart';
import 'package:my_portfolio/core/shared/widgets/lists/card.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/title_text.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';

class AboutMeCard extends ConsumerWidget {
  const AboutMeCard({super.key, required this.profile});

  final ProfileEntity profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ===== PROFILE IMAGE =====
        GlowCircleImage(image: profile.image, size: 140),

        const SizedBox(height: 24),

        // ===== TITLE =====
        const AppSubtitle('Flutter Developer', textAlign: TextAlign.center),

        const SizedBox(height: 16),

        // ===== ABOUT TEXT =====
        AppBodyText(profile.about, textAlign: TextAlign.center, softWrap: true),
      ],
    );
  }
}
