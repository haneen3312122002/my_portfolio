import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file/cross_file.dart';

import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/presentation/viewmodels/project_viewmodel.dart';

class ProjectsDebugPanel extends ConsumerStatefulWidget {
  const ProjectsDebugPanel({super.key});

  @override
  ConsumerState<ProjectsDebugPanel> createState() => _ProjectsDebugPanelState();
}

class _ProjectsDebugPanelState extends ConsumerState<ProjectsDebugPanel> {
  final _picker = ImagePicker();

  XFile? _cover;
  List<XFile> _images = [];
  List<XFile> _icons = [];

  Future<void> _pickCover() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() => _cover = file);
  }

  Future<void> _pickImages() async {
    final files = await _picker.pickMultiImage();
    if (files.isEmpty) return;
    setState(() => _images = files);
  }

  Future<void> _pickIcons() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    // اعتبريها أيقونة واحدة (أو عدليها لعدة)
    setState(() => _icons = [file]);
  }

  void _clearPicked() {
    setState(() {
      _cover = null;
      _images = [];
      _icons = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Projects Debug (Uploads)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            async.when(
              data: (list) => Text('Count: ${list.length}'),
              loading: () => const Text('Loading...'),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 12),

            // ===== Pickers preview =====
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _FileChip(
                  label: _cover == null ? 'Pick Cover' : 'Cover ✓',
                  onTap: _pickCover,
                  onClear: _cover == null
                      ? null
                      : () => setState(() => _cover = null),
                ),
                _FileChip(
                  label: _images.isEmpty
                      ? 'Pick Images'
                      : 'Images (${_images.length}) ✓',
                  onTap: _pickImages,
                  onClear: _images.isEmpty
                      ? null
                      : () => setState(() => _images = []),
                ),
                _FileChip(
                  label: _icons.isEmpty ? 'Pick Icon' : 'Icon ✓',
                  onTap: _pickIcons,
                  onClear: _icons.isEmpty
                      ? null
                      : () => setState(() => _icons = []),
                ),
                OutlinedButton.icon(
                  onPressed: _clearPicked,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear picked'),
                ),
              ],
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

            const SizedBox(height: 10),

            // ===== CREATE with uploads =====
            ElevatedButton(
              onPressed: () async {
                debugPrint('TEST: addProject(with uploads)');

                final p = ProjectEntity(
                  id: 'temp',
                  title:
                      'Test Project ${DateTime.now().millisecondsSinceEpoch}',
                  description: 'Created from debug panel',
                  coverImage: '', // رح يتعبّى بعد الرفع
                  links: const [],
                  projectImages: const [],
                  projectIcons: const [],
                );

                final id = await ref
                    .read(projectsProvider.notifier)
                    .addProject(
                      project: p,
                      coverFile: _cover,
                      imageFiles: _images,
                      iconFiles: _icons,
                    );

                debugPrint('DONE: addProject => id: $id');
                await ref.read(projectsProvider.notifier).refresh();
              },
              child: const Text('Add Project (With Uploads)'),
            ),

            const SizedBox(height: 10),

            // ===== UPDATE first project (replace uploads) =====
            ElevatedButton(
              onPressed: () async {
                final list = ref.read(projectsProvider).value ?? [];
                if (list.isEmpty) {
                  debugPrint('No projects to update');
                  return;
                }

                final oldP = list.first;
                final newP = oldP.copyWith(title: '${oldP.title} (updated)');

                debugPrint('TEST: updateProject(with uploads) id: ${oldP.id}');
                await ref
                    .read(projectsProvider.notifier)
                    .updateProject(
                      oldProject: oldP,
                      newProject: newP,
                      newCoverFile: _cover,
                      newImageFiles: _images,
                      newIconFiles: _icons,
                      deleteOldFiles: true,
                    );

                debugPrint('DONE: updateProject()');
                await ref.read(projectsProvider.notifier).refresh();
              },
              child: const Text('Update First Project (Replace Uploads)'),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 10),

            // ===== Display projects + images =====
            Expanded(
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (list) {
                  if (list.isEmpty) {
                    return const Center(child: Text('No projects yet'));
                  }
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => _ProjectCard(list[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _FileChip({required this.label, required this.onTap, this.onClear});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label),
      onPressed: onTap,
      deleteIcon: onClear == null ? null : const Icon(Icons.close),
      onDeleted: onClear,
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectEntity p;
  const _ProjectCard(this.p);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis),

            const SizedBox(height: 10),

            // Cover
            if (p.coverImage.isNotEmpty) ...[
              const Text('Cover:'),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    p.coverImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Text('Cover load error')),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Images
            if (p.projectImages.isNotEmpty) ...[
              Text('Images (${p.projectImages.length}):'),
              const SizedBox(height: 6),
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: p.projectImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final url = p.projectImages[i];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        url,
                        width: 120,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(
                          width: 120,
                          child: Center(child: Text('Error')),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Icons
            if (p.projectIcons.isNotEmpty) ...[
              Text('Icons (${p.projectIcons.length}):'),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: p.projectIcons.map((url) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(child: Text('x')),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
