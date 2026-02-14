import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_portfolio/core/shared/utils/helpers.dart'; // openLinkSmart
import 'package:my_portfolio/core/shared/widgets/buttons/social_icon_button.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

import 'package:my_portfolio/modules/profile/domain/entites/social_link.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/profile_service_provider.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/profile/profile_viewmodle.dart';

class SocialLinksSection extends ConsumerWidget {
  const SocialLinksSection({super.key, this.iconSize = 28});

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(profileProvider);
    final isEdit = ref.watch(isEditProvider);

    return asyncProfile.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (profile) {
        final links = profile.socialLinks;
        if (links.isEmpty && !isEdit) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, c) {
            final isMobile = c.maxWidth < 650;

            final children = <Widget>[
              // ✅ Add button يظهر فقط بوضع edit
              if (isEdit)
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: _AddSocialIconButton(
                    size: iconSize,
                    onTap: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const _UpsertSocialLinkDialog(),
                      );
                    },
                  ),
                ),

              for (final item in links)
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: _EditableSocialIcon(
                    item: item,
                    size: iconSize,
                    isEdit: isEdit,
                  ),
                ),
            ];

            // ✅ Web: Row ✅ Mobile: Column
            return isMobile
                ? Column(mainAxisSize: MainAxisSize.min, children: children)
                : Row(mainAxisSize: MainAxisSize.min, children: children);
          },
        );
      },
    );
  }
}

class _AddSocialIconButton extends StatefulWidget {
  const _AddSocialIconButton({required this.size, required this.onTap});

  final double size;
  final VoidCallback onTap;

  @override
  State<_AddSocialIconButton> createState() => _AddSocialIconButtonState();
}

class _AddSocialIconButtonState extends State<_AddSocialIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final glow = AppColors.heading;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: widget.size + 16,
          height: widget.size + 16,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.divider),
            color: AppColors.card.withOpacity(0.35),
            boxShadow: [
              BoxShadow(
                color: glow.withOpacity(_hover ? 0.22 : 0.12),
                blurRadius: _hover ? 22 : 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(Icons.add, size: widget.size, color: AppColors.body),
        ),
      ),
    );
  }
}

class _EditableSocialIcon extends ConsumerStatefulWidget {
  const _EditableSocialIcon({
    required this.item,
    required this.size,
    required this.isEdit,
  });

  final SocialItem item;
  final double size;
  final bool isEdit;

  @override
  ConsumerState<_EditableSocialIcon> createState() =>
      _EditableSocialIconState();
}

class _EditableSocialIconState extends ConsumerState<_EditableSocialIcon> {
  final _anchorKey = GlobalKey();

  Future<void> _openMenu() async {
    final renderBox =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final pos = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(Offset.zero, ancestor: overlay),
        renderBox.localToGlobal(
          renderBox.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final action = await showMenu<String>(
      context: context,
      position: pos,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.divider),
      ),
      items: const [
        PopupMenuItem(value: 'edit', child: AppBodyText('Edit')),
        PopupMenuItem(value: 'delete', child: AppBodyText('Delete')),
      ],
    );

    if (!mounted || action == null) return;

    if (action == 'edit') {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _UpsertSocialLinkDialog(editing: widget.item),
      );
    } else if (action == 'delete') {
      await _delete();
    }
  }

  Future<void> _delete() async {
    final title = (widget.item.name?.trim().isNotEmpty ?? false)
        ? widget.item.name!.trim()
        : 'Link';

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const AppBodyText('Delete link?'),
        content: AppBodyText('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const AppBodyText('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const AppBodyText('Delete'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final profile = ref.read(profileProvider).value;
    if (profile == null) return;

    final updated = profile.socialLinks
        .where(
          (e) => e.url != widget.item.url || e.iconUrl != widget.item.iconUrl,
        )
        .map((e) => e.toMap())
        .toList();

    await ref.read(profileProvider.notifier).updateProfileFields({
      'socialLinks': updated,
    });

    ref.invalidate(profileProvider);
  }

  @override
  Widget build(BuildContext context) {
    // ✅ normal click: open link
    // ✅ edit mode: right click / long press => menu
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: _anchorKey,

        // ✅ أهم تعديل
        onTap: widget.isEdit ? _openMenu : () => openLinkSmart(widget.item.url),

        // ✅ (اختياري) خليها موجودة كـ backup للموبايل
        onLongPress: widget.isEdit ? _openMenu : null,

        // ✅ (اختياري) right click للويب
        onSecondaryTapDown: widget.isEdit ? (_) => _openMenu() : null,

        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SocialGlowButton(item: widget.item, size: widget.size),

            if (widget.isEdit)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Icon(Icons.more_horiz, size: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UpsertSocialLinkDialog extends ConsumerStatefulWidget {
  const _UpsertSocialLinkDialog({this.editing});

  final SocialItem? editing;

  @override
  ConsumerState<_UpsertSocialLinkDialog> createState() =>
      _UpsertSocialLinkDialogState();
}

class _UpsertSocialLinkDialogState
    extends ConsumerState<_UpsertSocialLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _urlCtrl;

  Uint8List? _pickedBytes;
  String? _pickedFileName;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.editing?.name ?? '');
    _urlCtrl = TextEditingController(text: widget.editing?.url ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  String? _urlValidator(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'URL is required';
    if (!t.startsWith('http')) return 'URL must start with http/https';
    return null;
  }

  Future<void> _pickIcon() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final f = result.files.single;
    if (f.bytes == null) return;

    setState(() {
      _pickedBytes = f.bytes!;
      _pickedFileName = f.name;
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final profile = ref.read(profileProvider).value;
    if (profile == null) return;

    setState(() => _saving = true);

    try {
      final useCase = ref.read(profileUseCaseProvider);

      // 1) upload icon if picked (else keep old iconUrl)
      String? iconUrl = widget.editing?.iconUrl;
      if (_pickedBytes != null && _pickedFileName != null) {
        iconUrl = await useCase.uploadSocialIcon(
          bytes: _pickedBytes!,
          originalFileName: _pickedFileName!,
        );
      }

      final newItem = SocialItem(
        url: _urlCtrl.text.trim(),
        name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
        iconUrl: (iconUrl?.trim().isNotEmpty ?? false) ? iconUrl : null,
        iconCodePoint: widget.editing?.iconCodePoint,
      );

      final old = widget.editing;

      final updatedLinks = <Map<String, dynamic>>[
        for (final e in profile.socialLinks)
          if (old != null &&
              e.url == old.url &&
              (e.iconUrl ?? '') == (old.iconUrl ?? '') &&
              (e.name ?? '') == (old.name ?? ''))
            newItem.toMap()
          else
            e.toMap(),
      ];

      if (old == null) updatedLinks.add(newItem.toMap());

      await ref.read(profileProvider.notifier).updateProfileFields({
        'socialLinks': updatedLinks,
      });

      ref.invalidate(profileProvider);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: AppBodyText('Failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editing != null;

    return AlertDialog(
      title: AppBodyText(
        isEdit ? 'Edit Social Link' : 'Add Social Link',
        wstyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: 560,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name (optional)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _urlCtrl,
                decoration: const InputDecoration(labelText: 'URL'),
                validator: _urlValidator,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: AppBodyText(
                      _pickedFileName != null
                          ? 'Icon: $_pickedFileName'
                          : (isEdit &&
                                (widget.editing?.iconUrl?.isNotEmpty ?? false))
                          ? 'Icon: existing'
                          : 'No icon selected',
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: _saving ? null : _pickIcon,
                    icon: const Icon(Icons.upload),
                    label: const AppBodyText('Pick icon'),
                  ),
                  if (_pickedBytes != null) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: _saving
                          ? null
                          : () => setState(() {
                              _pickedBytes = null;
                              _pickedFileName = null;
                            }),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const AppBodyText('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: AppBodyText(_saving ? 'Saving…' : (isEdit ? 'Save' : 'Add')),
        ),
      ],
    );
  }
}
