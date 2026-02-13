import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'package:image_picker/image_picker.dart' as ip;

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
//............

Future<XFile?> pickOneImageXFile(ip.ImagePicker picker) async {
  final file = await picker.pickImage(
    source: ip.ImageSource.gallery,
    imageQuality: 85,
  );
  return file == null ? null : XFile(file.path);
}

Future<List<XFile>> pickManyImagesXFile(ip.ImagePicker picker) async {
  final files = await picker.pickMultiImage(imageQuality: 85);
  return files.map((f) => XFile(f.path)).toList();
}
