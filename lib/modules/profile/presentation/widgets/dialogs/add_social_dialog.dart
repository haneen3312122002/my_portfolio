import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/errors/error_mapper.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/outline_button.dart';
import 'package:my_portfolio/core/helpers/image_picker.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/social_image_viewmodel.dart';

class AddSocialLinkDialog extends ConsumerWidget {
  const AddSocialLinkDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(profileDraftProvider);
    final pickedName = draft['social_icon_name'] as String?;
    final uploadState = ref.watch(socialIconUploadProvider);

    ref.listen(socialIconUploadProvider, (previous, next) {
      next.whenOrNull(
        error: (e, _) {
          final msg = AppErrorMapper.map(e);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg.message)));
        },
      );
    });

    final isLoading = uploadState.isLoading;

    return AlertDialog(
      title: const Text('Add link'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: (draft['social_url'] ?? '') as String,
            onChanged: (v) => setDraft(ref, 'social_url', v),
            decoration: const InputDecoration(
              hintText: 'https://... أو mailto:... أو tel:...',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AppOutlineButton(
                title: 'add icon',
                onPressed: isLoading
                    ? null
                    : () async {
                        final PickedImageResult? res = await pickImage();
                        if (res != null) {
                          setDraft(ref, 'social_icon_name', res.name);
                          setDraft(ref, 'social_icon_bytes', res.bytes);
                        }
                      },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  pickedName ?? 'No file selected',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // ✅ Loading indicator داخل الديالوج
          if (isLoading) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: isLoading
              ? null
              : () async {
                  final url = (draft['social_url'] ?? '').toString().trim();
                  if (url.isEmpty) return;

                  await ref
                      .read(socialIconUploadProvider.notifier)
                      .uploadFromDraftAndSaveToProfile(
                        linkUrl: url,
                        displayName: pickedName,
                      );

                  // ✅ سكّري بس إذا ما صار خطأ
                  if (context.mounted &&
                      !ref.read(socialIconUploadProvider).hasError) {
                    Navigator.pop(context);
                  }
                },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
