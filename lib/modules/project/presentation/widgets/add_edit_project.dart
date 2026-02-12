import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_file/cross_file.dart';
import 'package:image_picker/image_picker.dart' as ip;

import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/presentation/providers/project_state_providers.dart';
import 'package:my_portfolio/modules/project/presentation/viewmodels/project_viewmodel.dart';
import 'package:my_portfolio/modules/profile/domain/entites/social_link.dart';

// ✅ إذا عندك imagePickerProvider موجود بمكان ثاني، احذفي هذا التعريف واستورديه فقط.
// ignore: non_constant_identifier_names
final imagePickerProvider = Provider<ip.ImagePicker>((ref) => ip.ImagePicker());

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

  final List<SocialItem> _links = [];

  // Upload files
  XFile? _coverFile;
  final List<XFile> _imageFiles = [];
  final List<XFile> _iconFiles = [];

  // Existing URLs (عرض فقط + fallback بالـ submit)
  final List<String> _existingImages = [];
  final List<String> _existingIcons = [];

  bool _deleteOldFiles = true;

  @override
  void initState() {
    super.initState();

    final editing = ref.read(editingProjectProvider);

    _titleCtrl = TextEditingController(text: editing?.title ?? '');
    _descCtrl = TextEditingController(text: editing?.description ?? '');
    _coverUrlCtrl = TextEditingController(text: editing?.coverImage ?? '');

    if (editing != null) {
      _links.addAll(editing.links);
      _existingImages.addAll(editing.projectImages);
      _existingIcons.addAll(editing.projectIcons);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _coverUrlCtrl.dispose();
    super.dispose();
  }

  // ===================== PICKERS =====================
  Future<void> _pickCover() async {
    final picker = ref.read(imagePickerProvider);
    final file = await picker.pickImage(
      source: ip.ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;
    setState(() => _coverFile = XFile(file.path));
  }

  Future<void> _pickImages() async {
    final picker = ref.read(imagePickerProvider);
    final files = await picker.pickMultiImage(imageQuality: 85);
    if (files.isEmpty) return;
    setState(() => _imageFiles.addAll(files.map((f) => XFile(f.path))));
  }

  Future<void> _pickIcons() async {
    final picker = ref.read(imagePickerProvider);
    final files = await picker.pickMultiImage(imageQuality: 85);
    if (files.isEmpty) return;
    setState(() => _iconFiles.addAll(files.map((f) => XFile(f.path))));
  }

  // ===================== SUBMIT =====================
  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final vm = ref.read(projectsProvider.notifier);
    final editing = ref.read(editingProjectProvider);

    final isEdit = widget.isEdit && editing != null;

    // ✅ fallback حسب منطق ProjectService:
    // لو ما في ملفات جديدة، خليه يضل على URLs القديمة
    // ولو في ملفات جديدة، الـ service رح يستبدلها (replace) ويكتب URLs الجديدة
    final imagesForEntity = _existingImages;
    final iconsForEntity = _existingIcons;

    final base = ProjectEntity(
      id: isEdit ? editing.id : '', // بالـ Add مش مهم (service بعمل docId)
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      coverImage: _coverUrlCtrl.text.trim(),
      links: List.unmodifiable(_links),
      projectImages: List.unmodifiable(imagesForEntity),
      projectIcons: List.unmodifiable(iconsForEntity),
    );

    try {
      if (isEdit) {
        await vm.updateProject(
          oldProject: editing,
          newProject: base,
          newCoverFile: _coverFile,
          newImageFiles: _imageFiles,
          newIconFiles: _iconFiles,
          deleteOldFiles: _deleteOldFiles,
        );
      } else {
        await vm.addProject(
          project: base,
          coverFile: _coverFile,
          imageFiles: _imageFiles,
          iconFiles: _iconFiles,
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    }
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(projectsProvider);
    final isLoading = async.isLoading;

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
                        _coverFile == null
                            ? 'No cover file selected'
                            : 'Cover file: ${_coverFile!.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : _pickCover,
                      icon: const Icon(Icons.upload),
                      label: const Text('Pick file'),
                    ),
                    if (_coverFile != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: isLoading
                            ? null
                            : () => setState(() => _coverFile = null),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ],
                ),

                _sectionTitle('Project Images'),
                if (_existingImages.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _existingImages
                        .map(
                          (url) => Chip(
                            label: Text(url, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                  ),

                if (_imageFiles.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _imageFiles
                        .map(
                          (f) => Chip(
                            label: Text(
                              f.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onDeleted: isLoading
                                ? null
                                : () => setState(() => _imageFiles.remove(f)),
                          ),
                        )
                        .toList(),
                  ),
                ],

                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text('New image files: ${_imageFiles.length}'),
                    ),
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : _pickImages,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: const Text('Add files'),
                    ),
                    const SizedBox(width: 8),
                    if (_imageFiles.isNotEmpty)
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => setState(_imageFiles.clear),
                        child: const Text('Clear'),
                      ),
                  ],
                ),

                _sectionTitle('Project Icons'),
                if (_existingIcons.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _existingIcons
                        .map(
                          (url) => Chip(
                            label: Text(url, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                  ),

                if (_iconFiles.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _iconFiles
                        .map(
                          (f) => Chip(
                            label: Text(
                              f.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onDeleted: isLoading
                                ? null
                                : () => setState(() => _iconFiles.remove(f)),
                          ),
                        )
                        .toList(),
                  ),
                ],

                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text('New icon files: ${_iconFiles.length}'),
                    ),
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : _pickIcons,
                      icon: const Icon(Icons.add),
                      label: const Text('Add files'),
                    ),
                    const SizedBox(width: 8),
                    if (_iconFiles.isNotEmpty)
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => setState(_iconFiles.clear),
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
                              builder: (_) => const _AddLinkDialog(),
                            );
                            if (item != null) setState(() => _links.add(item));
                          },
                    icon: const Icon(Icons.add_link),
                    label: const Text('Add link'),
                  ),
                ),
                const SizedBox(height: 8),
                ..._links.asMap().entries.map((e) {
                  final item = e.value;
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.name ?? ''),
                    subtitle: Text(item.url),
                    trailing: IconButton(
                      onPressed: isLoading
                          ? null
                          : () => setState(() => _links.removeAt(e.key)),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  );
                }),

                if (widget.isEdit) ...[
                  _sectionTitle('Update options'),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _deleteOldFiles,
                    onChanged: isLoading
                        ? null
                        : (v) => setState(() => _deleteOldFiles = v),
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
          onPressed: isLoading ? null : _submit,
          child: Text(
            isLoading ? 'Please wait…' : (widget.isEdit ? 'Save' : 'Add'),
          ),
        ),
      ],
    );
  }
}

class _AddLinkDialog extends StatefulWidget {
  const _AddLinkDialog();

  @override
  State<_AddLinkDialog> createState() => _AddLinkDialogState();
}

class _AddLinkDialogState extends State<_AddLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Link'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _urlCtrl,
                decoration: const InputDecoration(labelText: 'URL'),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'URL required';
                  if (!t.startsWith('http'))
                    return 'URL must start with http/https';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;

            final item = SocialItem(
              name: _titleCtrl.text.trim(),
              url: _urlCtrl.text.trim(),
            );

            Navigator.pop(context, item);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
