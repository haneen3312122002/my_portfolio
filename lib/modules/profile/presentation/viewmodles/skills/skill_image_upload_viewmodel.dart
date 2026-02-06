import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/skills_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/skills/skills_viewmodel.dart';

final imagePickerProvider = Provider<ip.ImagePicker>((ref) => ip.ImagePicker());

final skillImageUploadProvider =
    AsyncNotifierProvider<SkillImageUploadViewModel, void>(
      SkillImageUploadViewModel.new,
    );

class SkillImageUploadViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// skillId: الدوك id داخل collection skills
  Future<void> pickAndUploadSkillImage({required String skillId}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final picker = ref.read(imagePickerProvider);

      final file = await picker.pickImage(
        source: ip.ImageSource.gallery,
        imageQuality: 85,
      );

      if (file == null) return;

      // ✅ حوّليه لـ cross_file
      final XFile xfile = XFile(file.path);

      final useCase = ref.read(skillUseCaseProvider);

      final url = await useCase.uploadSkillImageAndUpdate(
        skillId: skillId,
        file: xfile,
        fieldName: 'imageUrl',
      );

      if (url == null || url.isEmpty) return;

      // ✅ عشان UI يتحدث (جيب القائمة من جديد)
      ref.invalidate(skillsProvider);

      debugPrint('SKILL image uploaded => $url');
    });
  }
}
