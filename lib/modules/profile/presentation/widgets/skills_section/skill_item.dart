import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/utils/helpers.dart';
import 'package:my_portfolio/core/shared/widgets/sliders/animated_progress_bar.dart';
import 'package:my_portfolio/core/shared/widgets/cards/ship.dart';
import 'package:my_portfolio/core/shared/widgets/lists/list_tile.dart';

import 'package:my_portfolio/modules/profile/domain/entites/skill_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/skills/skills_expanded_viewmocel.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/skills/skills_viewmodel.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/skills_section/add_skill_dialog.dart';

class SkillItem extends ConsumerWidget {
  const SkillItem({super.key, required this.skill});

  final SkillEntity skill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = ref.watch(isEditProvider);
    final isOpen = ref.watch(
      skillsExpandedProvider.select((m) => m[skill.id] ?? false),
    );

    final c = mycolorFromHex(skill.barColorHex!);
    final progress = (skill.proficiency.clamp(0, 100)) / 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTile(
          leading: _SkillImage(url: skill.imageUrl),
          title: skill.name,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${skill.proficiency}%',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: c),
              ),
              const SizedBox(width: 6),

              // ⬆⬇ expand / collapse
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () {
                  ref.read(skillsExpandedProvider.notifier).toggle(skill.id);
                },
                icon: Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: c,
                  size: 22,
                ),
              ),

              if (isEdit) ...[
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => AddSkillDialog(skill: skill),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete skill?'),
                        content: Text('Delete "${skill.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (ok == true) {
                      await ref
                          .read(skillsProvider.notifier)
                          .deleteSkill(skill.id);
                    }
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                ),
              ],
            ],
          ),
          subtitle: AnimatedProgressBar(value: progress, color: c),
        ),

        // 🧩 sub skills
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: isOpen && skill.subSkills.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: c.withOpacity(0.35)),
                    ),
                    child: SkillsChips(skills: skill.subSkills, chipColor: c),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
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
            : Image.network(url, fit: BoxFit.cover, gaplessPlayback: true),
      ),
    );
  }
}
