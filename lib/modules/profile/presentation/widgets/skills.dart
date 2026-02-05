import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/widgets/animations/animated_progress_bar.dart';
import 'package:my_portfolio/core/shared/widgets/animations/fadein.dart';
import 'package:my_portfolio/core/shared/widgets/lists/app_responsive_grid.dart';
import 'package:my_portfolio/core/shared/widgets/lists/list_tile.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/profile_viewmodle.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      data: (profile) {
        final skills = profile.skills;

        if (skills.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏷️ Title (اختياري)
              AppFadeIn(
                duration: const Duration(milliseconds: 1500),
                child: AppSubtitle('My Top Skills'),
              ),
              const SizedBox(height: 16),

              // 🧩 Responsive Grid
              AppResponsiveGrid(
                itemCount: skills.length,
                mobile: 1,
                tablet: 2,
                desktop: 3,
                childAspectRatio: 3.2, // مستطيل أفقي
                gap: 16,
                runGap: 16,
                itemBuilder: (context, index) {
                  final skill = skills[index];

                  return AppTile(
                    title: skill,
                    trailing: const Icon(Icons.star, color: Colors.amber),
                    // 👇 تقدري توسعيه لاحقًا
                    subtitle: AnimatedProgressBar(
                      duration: const Duration(milliseconds: 3000),
                      value: 0.8,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
