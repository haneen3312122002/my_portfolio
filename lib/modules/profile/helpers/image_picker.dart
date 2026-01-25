import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

void setDraft(WidgetRef ref, String key, dynamic value) {
  final draft = {...ref.read(profileDraftProvider)};
  draft[key] = value;
  ref.read(profileDraftProvider.notifier).state = draft;
}
//..........

/// Pick image file and return bytes + extension
Future<PickedImageResult?> pickImage() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true,
  );

  if (result == null || result.files.isEmpty) return null;

  final file = result.files.single;

  if (file.bytes == null) return null;

  return PickedImageResult(
    bytes: file.bytes!,
    name: file.name,
    extension: file.extension ?? 'png',
  );
}

class PickedImageResult {
  final Uint8List bytes;
  final String name;
  final String extension;

  const PickedImageResult({
    required this.bytes,
    required this.name,
    required this.extension,
  });
}
