import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_portfolio/modules/profile/domain/entites/skill_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/skills/skills_viewmodel.dart';
// ↑ عدّلي المسار حسب عندك

class SkillsDebugPanel extends ConsumerWidget {
  const SkillsDebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(skillsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Skills Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            async.when(
              data: (list) => Text('Count: ${list.length}'),
              loading: () => const Text('Loading...'),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                debugPrint('TEST: refresh()');
                await ref.read(skillsProvider.notifier).refresh();
                debugPrint('DONE: refresh()');
              },
              child: const Text('Refresh'),
            ),

            ElevatedButton(
              onPressed: () async {
                debugPrint('TEST: upsertSkill() (add)');

                final s = SkillEntity(
                  id: 'skill_${DateTime.now().millisecondsSinceEpoch}',
                  name: 'Test Skill ${DateTime.now().millisecondsSinceEpoch}',
                  imageUrl: '',
                  proficiency: 80,
                  subSkills: const ['Sub 1', 'Sub 2'],
                );

                await ref.read(skillsProvider.notifier).upsertSkill(s);

                debugPrint('DONE: upsertSkill() (add)');
              },
              child: const Text('Add Skill'),
            ),

            ElevatedButton(
              onPressed: () async {
                final list = ref.read(skillsProvider).value ?? [];
                if (list.isEmpty) {
                  debugPrint('No skills to update');
                  return;
                }

                final oldS = list.first;

                final newS = SkillEntity(
                  id: oldS.id,
                  name: '${oldS.name} (updated)',
                  imageUrl: oldS.imageUrl,
                  proficiency: (oldS.proficiency + 5).clamp(0, 100),
                  subSkills: oldS.subSkills,
                );

                debugPrint('TEST: upsertSkill() (update) id: ${oldS.id}');
                await ref.read(skillsProvider.notifier).upsertSkill(newS);
                debugPrint('DONE: upsertSkill() (update)');
              },
              child: const Text('Update First Skill'),
            ),

            ElevatedButton(
              onPressed: () async {
                final list = ref.read(skillsProvider).value ?? [];
                if (list.isEmpty) {
                  debugPrint('No skills to delete');
                  return;
                }

                final s = list.first;
                debugPrint('TEST: deleteSkill() id: ${s.id}');
                await ref.read(skillsProvider.notifier).deleteSkill(s.id);
                debugPrint('DONE: deleteSkill()');
              },
              child: const Text('Delete First Skill'),
            ),
          ],
        ),
      ),
    );
  }
}
