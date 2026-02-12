import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/presentation/widgets/project_images.dart';
import 'package:my_portfolio/modules/project/presentation/widgets/add_edit_project.dart';

import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/project/presentation/providers/project_state_providers.dart';
import 'package:my_portfolio/modules/project/presentation/viewmodels/project_viewmodel.dart';

class ProjectGridItem extends ConsumerWidget {
  final ProjectEntity project;
  const ProjectGridItem({super.key, required this.project});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ProjectEntity project,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete project?'),
        content: Text('Are you sure you want to delete "${project.title}"?'),
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

    if (ok != true) return;

    await ref.read(projectsProvider.notifier).deleteProject(project);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Project deleted')));
    }
  }

  void _openEditDialog(BuildContext context, WidgetRef ref) {
    ref.read(isEditProvider.notifier).state = true;
    ref.read(editingProjectProvider.notifier).state = project;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ProjectUpsertDialog(isEdit: true),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cover = project.coverImage;
    final imgs = project.projectImages;

    final isEdit = ref.watch(isEditProvider);
    final isBusy = ref.watch(projectsProvider).isLoading;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ ألوان واضحة حسب الثيم (حتى ما "يختفي" على الموبايل)
    final bgColor = isDark ? const Color(0x14FFFFFF) : const Color(0x0F000000);
    final borderColor = isDark
        ? const Color(0x33FFFFFF)
        : const Color(0x22000000);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          debugPrint('Open project: ${project.id}');
        },
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.18 : 0.10),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== TITLE ======
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 8),
                  child: AppSubtitle(
                    project.title,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),

                // ====== IMAGE AREA ======
                // ====== IMAGE AREA ======
                LayoutBuilder(
                  builder: (context, c) {
                    final w = c.maxWidth;

                    final coverH = (w * 0.55).clamp(180.0, 260.0);
                    final extraBottom = (w * 0.22).clamp(55.0, 95.0);

                    return ProjectShowcaseStack(
                      coverUrl: cover,
                      projectImageUrls: imgs,
                      coverHeight: coverH,
                      extraBottom: extraBottom,
                      overlapOnCover: 70,
                    );
                  },
                ),

                const SizedBox(height: 10),

                // ====== ACTIONS (only in edit mode) ======
                if (isEdit) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isBusy
                              ? null
                              : () => _openEditDialog(context, ref),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isBusy
                              ? null
                              : () => _confirmDelete(context, ref, project),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // ✅ spacer بسيط عشان ارتفاع الكارد يكون ثابت شوي
                  const SizedBox(height: 44),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
