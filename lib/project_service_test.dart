import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_file/cross_file.dart';

import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/presentation/viewmodels/project_viewmodel.dart';
// ↑ عدّلي المسار حسب عندك

class ProjectsDebugPanel extends ConsumerWidget {
  const ProjectsDebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Projects Debug')),
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
                await ref.read(projectsProvider.notifier).refresh();
                debugPrint('DONE: refresh()');
              },
              child: const Text('Refresh'),
            ),

            ElevatedButton(
              onPressed: () async {
                debugPrint('TEST: addProject()');

                final p = ProjectEntity(
                  id: 'temp', // غالبًا ما بينقرأ بالـ add (الـ doc id من فايرستور)
                  title:
                      'Test Project ${DateTime.now().millisecondsSinceEpoch}',
                  description: 'Created from debug panel',
                  coverImage: '', // لو بتستخدمي upload غيّريها
                  links: const [],
                  projectImages: const [],
                  projectIcons: const [],
                );

                final id = await ref
                    .read(projectsProvider.notifier)
                    .addProject(
                      project: p,
                      coverFile: null,
                      imageFiles: const <XFile>[],
                      iconFiles: const <XFile>[],
                    );

                debugPrint('DONE: addProject => id: $id');
              },
              child: const Text('Add Project (No Upload)'),
            ),

            ElevatedButton(
              onPressed: () async {
                final list = ref.read(projectsProvider).value ?? [];
                if (list.isEmpty) {
                  debugPrint('No projects to update');
                  return;
                }

                final oldP = list.first;
                final newP = oldP.copyWith(title: '${oldP.title} (updated)');

                debugPrint('TEST: updateProject() for id: ${oldP.id}');
                await ref
                    .read(projectsProvider.notifier)
                    .updateProject(
                      oldProject: oldP,
                      newProject: newP,
                      newCoverFile: null,
                      newImageFiles: const <XFile>[],
                      newIconFiles: const <XFile>[],
                    );
                debugPrint('DONE: updateProject()');
              },
              child: const Text('Update First Project'),
            ),

            ElevatedButton(
              onPressed: () async {
                final list = ref.read(projectsProvider).value ?? [];
                if (list.isEmpty) {
                  debugPrint('No projects to delete');
                  return;
                }

                final p = list.first;
                debugPrint('TEST: deleteProject() id: ${p.id}');
                await ref.read(projectsProvider.notifier).deleteProject(p);
                debugPrint('DONE: deleteProject()');
              },
              child: const Text('Delete First Project'),
            ),
          ],
        ),
      ),
    );
  }
}
