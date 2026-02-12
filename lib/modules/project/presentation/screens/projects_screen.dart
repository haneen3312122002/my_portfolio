import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_portfolio/core/shared/widgets/lists/app_responsive_grid.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/project/presentation/providers/project_state_providers.dart';
import 'package:my_portfolio/modules/project/presentation/viewmodels/project_viewmodel.dart';
import 'package:my_portfolio/modules/project/presentation/widgets/add_edit_project.dart';
import 'package:my_portfolio/modules/project/presentation/widgets/project_item.dart';

class ProjectsGridSection extends ConsumerWidget {
  const ProjectsGridSection({
    super.key,
    this.maxItems = 6,
    this.showTitle = true,
  });

  final int maxItems;
  final bool showTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(projectsProvider);
    final isEdit = ref.watch(isEditProvider);

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Center(
        child: Column(
          children: [
            Text('Error: $e'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.read(projectsProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (projects) {
        final list = (maxItems <= 0)
            ? projects
            : projects.take(maxItems).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle) ...[
              Row(
                children: [
                  const Expanded(child: AppSubtitle('My Projects')),
                  const SizedBox(width: 12),

                  // ✅ Add button (يفضل يظهر لما مش edit)
                  if (isEdit)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Project'),
                      onPressed: () {
                        ref.read(isEditProvider.notifier).state = false;

                        // ✅ add mode: clear editing entity
                        ref.read(editingProjectProvider.notifier).state = null;

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const ProjectUpsertDialog(isEdit: false),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            AppResponsiveGrid(
              useShell: false,
              itemCount: list.length,
              mobile: 1,
              tablet: 2,
              desktop: 3,
              gap: 16,
              runGap: 16,
              childAspectRatio: 0.85,
              itemBuilder: (context, index) {
                final p = list[index];
                return ProjectGridItem(project: p);
              },
            ),
          ],
        );
      },
    );
  }
}
