import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/social_icon_button.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/profile/profile_viewmodle.dart';

class SocialSection extends ConsumerWidget {
  final double iconSize;

  const SocialSection({super.key, this.iconSize = 44});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return profile.when(
      data: (profile) {
        if (profile.socialLinks.isEmpty) return const SizedBox.shrink();
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: profile.socialLinks
              .map((s) => SocialGlowButton(item: s, size: iconSize))
              .toList(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
