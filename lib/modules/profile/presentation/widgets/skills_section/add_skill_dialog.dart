import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:my_portfolio/core/shared/utils/helpers.dart'
    show colorFromHex, mycolorFromHex, myhexFromColor;

import 'package:my_portfolio/modules/profile/domain/entites/skill_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/skills/skills_viewmodel.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/skills/skill_image_upload_viewmodel.dart';

class AddSkillDialog extends ConsumerStatefulWidget {
  const AddSkillDialog({super.key, this.skill});

  /// لو مش null => Edit mode
  final SkillEntity? skill;

  @override
  ConsumerState<AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends ConsumerState<AddSkillDialog> {
  final _nameCtrl = TextEditingController();
  final _subCtrl = TextEditingController();

  int _proficiency = 80;
  Color _selectedColor = const Color(0xFF00C2FF);

  XFile? _pickedImage; // cross_file
  bool _saving = false;

  bool get _isEditMode => widget.skill != null;

  @override
  void initState() {
    super.initState();

    final s = widget.skill;
    if (s != null) {
      _nameCtrl.text = s.name;
      _subCtrl.text = s.subSkills.join('\n');
      _proficiency = s.proficiency.clamp(0, 100);
      _selectedColor = mycolorFromHex(s.barColorHex!);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _subCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ref.read(imagePickerProvider);
    final file = await picker.pickImage(
      source: ip.ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;

    setState(() {
      _pickedImage = XFile(file.path);
    });
  }

  List<String> _parseSubSkills(String raw) {
    return raw
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);

    try {
      final id = _isEditMode
          ? widget.skill!.id
          : 'skill_${DateTime.now().millisecondsSinceEpoch}';

      final skill = SkillEntity(
        id: id,
        name: name,
        // بالـ edit نخلي الصورة القديمة إذا ما اخترنا جديد
        imageUrl: _isEditMode ? widget.skill!.imageUrl : '',
        proficiency: _proficiency.clamp(0, 100),
        subSkills: _parseSubSkills(_subCtrl.text),
        barColorHex: myhexFromColor(_selectedColor),
      );

      // ✅ upsert (add أو update)
      await ref.read(skillsProvider.notifier).upsertSkill(skill);

      // ✅ لو في صورة جديدة فقط
      if (_pickedImage != null) {
        await ref
            .read(skillImageUploadProvider.notifier)
            .pickAndUploadSkillImage(skillId: id);
      }

      // ✅ تحديث UI
      ref.invalidate(skillsProvider);

      if (mounted) Navigator.pop(context);
    } catch (_) {
      rethrow;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Skill' : 'Add Skill'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Skill name',
                  hintText: 'Flutter, Firebase, Riverpod...',
                ),
              ),
              const SizedBox(height: 12),

              // proficiency
              Row(
                children: [
                  const Text('Proficiency'),
                  const Spacer(),
                  Text('${_proficiency.clamp(0, 100)}%'),
                ],
              ),
              Slider(
                value: _proficiency.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (v) => setState(() => _proficiency = v.round()),
              ),
              const SizedBox(height: 8),

              // subskills textarea
              TextField(
                controller: _subCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Sub skills (one per line)',
                  hintText: 'Dart\nClean Architecture\nFirebase Auth',
                ),
              ),
              const SizedBox(height: 12),

              // color picker
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Text('Bar color'),
                    const SizedBox(width: 12),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        Color temp = _selectedColor;

                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Pick color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: temp,
                                onColorChanged: (c) => temp = c,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        );

                        if (ok == true) {
                          setState(() => _selectedColor = temp);
                        }
                      },
                      child: const Text('Pick'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // image picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _pickedImage != null
                          ? _pickedImage!.name
                          : (_isEditMode && widget.skill!.imageUrl.isNotEmpty)
                          ? 'Current image set'
                          : 'No image selected',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: Text(_isEditMode ? 'Change' : 'Choose'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditMode ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
