import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart' as ip;

//to know if i can edit the profile or not:
final isEditProvider = StateProvider<bool>((ref) {
  return false;
});
//the profile draft data showed kn the screen before uploading
final profileDraftProvider = StateProvider<Map<String, dynamic>>((ref) => {});
// Image picker provider
final imagePickerProvider = Provider<ip.ImagePicker>((ref) => ip.ImagePicker());
final skillsReplayProvider = StateProvider<int>((ref) => 0);
