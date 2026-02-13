import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/presentation/providers/project_state_providers.dart';
import 'package:my_portfolio/modules/project/presentation/viewmodels/project_viewmodel.dart';
import 'package:my_portfolio/modules/project/presentation/widgets/add_edit_project.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';

Future<void> confirmDeleteProject(
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

void openEditProjectDialog(
  BuildContext context,
  WidgetRef ref,
  ProjectEntity project,
) {
  ref.read(isEditProvider.notifier).state = true;
  ref.read(editingProjectProvider.notifier).state = project;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const ProjectUpsertDialog(isEdit: true),
  );
}
