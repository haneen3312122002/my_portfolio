import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/errors/error_mapper.dart';
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
    final isEditVm = ref.read(isEditProvider.notifier);
    final editingProject = ref.watch(editingProjectProvider);
    final editingProjectVm = ref.read(editingProjectProvider.notifier);

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) {
        final msg = AppErrorMapper.map(e);
        return Center(child: Text('${msg.title}\n${msg.message}'));
      },

      data: (projects) {
        //to decide to view all projects / first X projects
        final list = (maxItems <= 0)
            ? projects
            : projects.take(maxItems).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle) ...[
              Row(
                children: [
                  const Expanded(child: AppSubtitle('Featured Projects')),
                  const SizedBox(width: 12),

                  //  Add button
                  if (isEdit)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Project'),
                      onPressed: () {
                        //no access for edit
                        isEditVm.state = false;
                        //  add mode: clear editing entity
                        editingProjectVm.state = null;

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

            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;

                // ✅ Mobile: List (ارتفاع ديناميكي، بدون ratio)
                if (w < 650) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) =>
                        ProjectGridItem(project: list[index]),
                  );
                }

                // ✅ Tablet/Desktop: Grid زي ما هو (بس ratio مناسب)
                final ratio = w < 1100 ? 0.78 : 0.85;

                return AppResponsiveGrid(
                  useShell: false,
                  itemCount: list.length,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                  gap: 16,
                  runGap: 16,
                  childAspectRatio: ratio,
                  itemBuilder: (context, index) =>
                      ProjectGridItem(project: list[index]),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
