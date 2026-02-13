import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_portfolio/modules/project/presentation/providers/project_state_providers.dart';
import 'package:my_portfolio/modules/project/presentation/viewmodels/project_upsert_viewmodel.dart';
import 'package:my_portfolio/modules/project/presentation/viewmodels/project_viewmodel.dart';
import 'package:my_portfolio/modules/profile/domain/entites/social_link.dart';
import 'package:my_portfolio/modules/project/presentation/widgets/add_links_dialog.dart';

/// Dialog used for both creating and editing a project.
/// The UI stays "dumb": all picking/uploading/mutations are handled by projectUpsertProvider.
class ProjectUpsertDialog extends ConsumerStatefulWidget {
  const ProjectUpsertDialog({super.key, required this.isEdit});
  final bool isEdit;

  @override
  ConsumerState<ProjectUpsertDialog> createState() =>
      _ProjectUpsertDialogState();
}

class _ProjectUpsertDialogState extends ConsumerState<ProjectUpsertDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _coverUrlCtrl;

  @override
  void initState() {
    super.initState();

    // If we're editing, pre-fill the fields from the selected project.
    final editing = ref.read(editingProjectProvider);

    _titleCtrl = TextEditingController(text: editing?.title ?? '');
    _descCtrl = TextEditingController(text: editing?.description ?? '');
    _coverUrlCtrl = TextEditingController(text: editing?.coverImage ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _coverUrlCtrl.dispose();

    // Clear upsert state so next time the dialog opens, it starts fresh.
    ref.invalidate(projectUpsertProvider);

    super.dispose();
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );

  @override
  Widget build(BuildContext context) {
    // We rely on projectsProvider loading state to disable actions during save/update.
    final asyncProjects = ref.watch(projectsProvider);
    final isLoading = asyncProjects.isLoading;

    // Dialog-specific state (picked files, links, flags...) comes from upsert provider.
    final upsert = ref.watch(projectUpsertProvider);
    final upsertVm = ref.read(projectUpsertProvider.notifier);

    final editing = ref.read(editingProjectProvider);
    final canEdit = widget.isEdit && editing != null;

    return AlertDialog(
      title: Text(widget.isEdit ? 'Edit Project' : 'Add Project'),
      content: SizedBox(
        width: 640,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descCtrl,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (v) => (v ?? '').trim().isEmpty
                      ? 'Description is required'
                      : null,
                ),

                _sectionTitle('Cover'),
                TextFormField(
                  controller: _coverUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cover URL (optional)',
                    hintText: 'If you upload a file, URL can be empty',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        upsert.coverFile == null
                            ? 'No cover file selected'
                            : 'Cover file: ${upsert.coverFile!.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : upsertVm.pickCover,
                      icon: const Icon(Icons.upload),
                      label: const Text('Pick file'),
                    ),
                    if (upsert.coverFile != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: isLoading ? null : upsertVm.clearCover,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ],
                ),

                _sectionTitle('Project Images'),
                if (upsert.existingImages.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: upsert.existingImages
                        .map(
                          (url) => Chip(
                            label: Text(url, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                  ),

                if (upsert.imageFiles.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: upsert.imageFiles
                        .map(
                          (f) => Chip(
                            label: Text(
                              f.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onDeleted: isLoading
                                ? null
                                : () => upsertVm.removeImageFile(f),
                          ),
                        )
                        .toList(),
                  ),
                ],

                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'New image files: ${upsert.imageFiles.length}',
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : upsertVm.pickImages,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: const Text('Add files'),
                    ),
                    const SizedBox(width: 8),
                    if (upsert.imageFiles.isNotEmpty)
                      TextButton(
                        onPressed: isLoading ? null : upsertVm.clearImageFiles,
                        child: const Text('Clear'),
                      ),
                  ],
                ),

                _sectionTitle('Project Icons'),
                if (upsert.existingIcons.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: upsert.existingIcons
                        .map(
                          (url) => Chip(
                            label: Text(url, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                  ),

                if (upsert.iconFiles.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: upsert.iconFiles
                        .map(
                          (f) => Chip(
                            label: Text(
                              f.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onDeleted: isLoading
                                ? null
                                : () => upsertVm.removeIconFile(f),
                          ),
                        )
                        .toList(),
                  ),
                ],

                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text('New icon files: ${upsert.iconFiles.length}'),
                    ),
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : upsertVm.pickIcons,
                      icon: const Icon(Icons.add),
                      label: const Text('Add files'),
                    ),
                    const SizedBox(width: 8),
                    if (upsert.iconFiles.isNotEmpty)
                      TextButton(
                        onPressed: isLoading ? null : upsertVm.clearIconFiles,
                        child: const Text('Clear'),
                      ),
                  ],
                ),

                _sectionTitle('Links'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final item = await showDialog<SocialItem>(
                              context: context,
                              builder: (_) => const AddLinkDialog(),
                            );
                            if (item != null) upsertVm.addLink(item);
                          },
                    icon: const Icon(Icons.add_link),
                    label: const Text('Add link'),
                  ),
                ),
                const SizedBox(height: 8),
                ...upsert.links.asMap().entries.map((e) {
                  final index = e.key;
                  final item = e.value;
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.name ?? ''),
                    subtitle: Text(item.url),
                    trailing: IconButton(
                      onPressed: isLoading
                          ? null
                          : () => upsertVm.removeLinkAt(index),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  );
                }),

                if (canEdit) ...[
                  _sectionTitle('Update options'),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: upsert.deleteOldFiles,
                    onChanged: isLoading ? null : upsertVm.setDeleteOldFiles,
                    title: const Text('Delete old files on replace'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  if (!(_formKey.currentState?.validate() ?? false)) return;

                  try {
                    await upsertVm.submit(
                      isEdit: widget.isEdit,
                      title: _titleCtrl.text,
                      description: _descCtrl.text,
                      coverUrl: _coverUrlCtrl.text,
                    );
                    if (context.mounted) Navigator.pop(context);
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Something went wrong. Please try again.',
                        ),
                      ),
                    );
                  }
                },
          child: Text(
            isLoading ? 'Please wait…' : (widget.isEdit ? 'Save' : 'Add'),
          ),
        ),
      ],
    );
  }
}
