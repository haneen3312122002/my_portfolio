import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/errors/error_mapper.dart';
import 'package:my_portfolio/core/shared/utils/helpers.dart';
import 'package:my_portfolio/core/shared/widgets/animations/fadein.dart';
import 'package:my_portfolio/core/shared/widgets/animations/written_text.dart';
import 'package:my_portfolio/core/shared/widgets/cards/ship.dart';
import 'package:my_portfolio/core/shared/widgets/lists/app_responsive_grid.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';

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
    final tick = ref.watch(skillsReplayProvider);
    return skillsAsync.when(
      data: (skills) {
        if (skills.isEmpty && !isEdit)
          return const Center(child: AppBodyText('No skills to show'));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                            builder: (_) => const AddSkillDialog(),
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;

                    // ✅ Mobile: استخدمي List عشان ما نقيّد ارتفاع العناصر بـ ratio
                    if (w < 650) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: skills.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            SkillItem(replayTick: tick, skill: skills[index]),
                      );
                    }

                    // ✅ Tablet/Desktop: خليه Grid زي ما هو
                    double gap;
                    double runGap;

                    // ✅ ratios للتابلت/الديسكتوب (مناسبة وما تعمل overflow)
                    final ratio = w < 1100 ? 2.2 : 3.0;

                    if (w < 1100) {
                      gap = 12;
                      runGap = 10;
                    } else {
                      gap = 16;
                      runGap = 12;
                    }

                    return AppResponsiveGrid(
                      itemCount: skills.length,
                      mobile: 1,
                      tablet: 2,
                      desktop: 3,
                      childAspectRatio: ratio,
                      gap: gap,
                      runGap: runGap,
                      itemBuilder: (context, index) =>
                          SkillItem(replayTick: tick, skill: skills[index]),
                    );
                  },
                ),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, __) {
        final msg = AppErrorMapper.map(e);
        return Center(child: Text('${msg.title}\n${msg.message}'));
      },
    );
  }
}
