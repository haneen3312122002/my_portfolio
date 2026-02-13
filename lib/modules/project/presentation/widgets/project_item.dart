import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/gradiant_button.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/outline_button.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';

import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/presentation/helpers/project_actions.dart';
import 'package:my_portfolio/modules/project/presentation/widgets/project_images.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/project/presentation/viewmodels/project_viewmodel.dart';

class ProjectGridItem extends ConsumerWidget {
  final ProjectEntity project;
  const ProjectGridItem({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cover = project.coverImage;
    final imgs = project.projectImages;

    final isEdit = ref.watch(isEditProvider);
    final isBusy = ref.watch(projectsProvider).isLoading;

    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== TITLE ======

                // ====== IMAGE AREA ======
                LayoutBuilder(
                  builder: (context, c) {
                    final w = c.maxWidth;
                    final coverH = (w * 0.55).clamp(180.0, 260.0);
                    final extraBottom = (w * 0.13).clamp(42.0, 73.0);

                    return ProjectShowcaseStack(
                      coverUrl: cover,
                      projectImageUrls: imgs,
                      coverHeight: coverH,
                      extraBottom: extraBottom,
                      overlapOnCover: 70,
                      isVertical: project.isVertical, // ✅ من الـ entity
                    );
                  },
                ),

                // const SizedBox(height: 2),
                AppBodyText(
                  project.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 20),

                // ====== ACTIONS ======
                if (isEdit) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isBusy
                              ? null
                              : () => openEditProjectDialog(
                                  context,
                                  ref,
                                  project,
                                ),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isBusy
                              ? null
                              : () =>
                                    confirmDeleteProject(context, ref, project),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          onPressed: null, // رح تفعليه بعدين
                          child: const Text(
                            'View Project',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppOutlineButton(
                          onPressed: null, // رح تفعليه بعدين
                          child: const AppBodyText('Details'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
