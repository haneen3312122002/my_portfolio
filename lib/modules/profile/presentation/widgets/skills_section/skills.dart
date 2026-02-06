import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/utils/helpers.dart';
import 'package:my_portfolio/core/shared/widgets/animations/animated_progress_bar.dart';
import 'package:my_portfolio/core/shared/widgets/animations/fadein.dart';
import 'package:my_portfolio/core/shared/widgets/cards/ship.dart';
import 'package:my_portfolio/core/shared/widgets/lists/app_responsive_grid.dart';
import 'package:my_portfolio/core/shared/widgets/lists/list_tile.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/skills/skills_expanded_viewmocel.dart';

import 'package:my_portfolio/modules/profile/presentation/viewmodles/skills/skills_viewmodel.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/skills_section/add_skill_dialog.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/skills_section/skill_item.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsAsync = ref.watch(skillsProvider);
    final isEdit = ref.watch(isEditProvider);
    final expandedMap = ref.watch(skillsExpandedProvider);
    final anyOpen = expandedMap.values.any((v) => v == true);

    return skillsAsync.when(
      data: (skills) {
        if (skills.isEmpty && !isEdit) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFadeIn(
                duration: const Duration(milliseconds: 1500),
                child: Row(
                  children: [
                    const Expanded(child: AppSubtitle('My Top Skills')),
                    if (isEdit)
                      ElevatedButton.icon(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => const AddSkillDialog(), // add
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Skill'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (skills.isEmpty && isEdit)
                const Text('No skills yet. Add your first one 👇'),

              if (skills.isNotEmpty)
                if (!anyOpen)
                  AppResponsiveGrid(
                    itemCount: skills.length,
                    mobile: 1,
                    tablet: 2,
                    desktop: 3,
                    childAspectRatio: 3.2,
                    gap: 16,
                    runGap: 16,
                    itemBuilder: (context, index) =>
                        SkillItem(skill: skills[index]),
                  )
                else
                  Column(
                    children: [
                      for (final s in skills) ...[
                        SkillItem(skill: s),
                        const SizedBox(height: 16),
                      ],
                    ],
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

class _SkillImage extends StatelessWidget {
  const _SkillImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 34,
        height: 34,
        child: url.isEmpty
            ? Container(
                color: Colors.white10,
                child: const Icon(Icons.image_not_supported, size: 18),
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.white10,
                  child: const Icon(Icons.broken_image, size: 18),
                ),
              ),
      ),
    );
  }
}

class _SubSkillsCard extends StatelessWidget {
  const _SubSkillsCard({required this.subSkills, required this.color});

  final List<String> subSkills;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: SkillsChips(
        skills: subSkills,
        chipColor: color, // ✅
      ),
    );
  }
}
