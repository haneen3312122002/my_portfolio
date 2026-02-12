import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:cross_file/cross_file.dart';

import 'package:my_portfolio/modules/project/presentation/providers/project_services_providers.dart';
// فيه usecaseProvider عندك

final projectMediaUploadProvider =
    AsyncNotifierProvider<ProjectMediaUploadViewModel, void>(
      ProjectMediaUploadViewModel.new,
    );

class ProjectMediaUploadViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<XFile?> pickOne() async {
    final picker = ip.ImagePicker();
    final file = await picker.pickImage(
      source: ip.ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return null;
    return XFile(file.path);
  }

  Future<List<XFile>> pickMany() async {
    final picker = ip.ImagePicker();
    final files = await picker.pickMultiImage(imageQuality: 85);
    return files.map((f) => XFile(f.path)).toList();
  }

  // ✅ Upload cover مباشرة (مفيد للـ edit)
  Future<String?> uploadCover({
    required String projectId,
    required XFile cover,
  }) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(() async {
      final useCase = ref.read(usecaseProvider);
      return useCase.uploadProjectCover(projectId: projectId, cover: cover);
    });

    state = res.isLoading ? const AsyncLoading() : const AsyncData(null);
    return res.value;
  }

  // ✅ Upload images/icons مباشرة
  Future<List<String>> uploadMany({
    required String projectId,
    required List<XFile> files,
    required String folderName, // images / icons
  }) async {
    if (files.isEmpty) return [];

    state = const AsyncLoading();
    final res = await AsyncValue.guard(() async {
      final useCase = ref.read(usecaseProvider);
      return useCase.uploadProjectMedia(
        projectId: projectId,
        files: files,
        folderName: folderName,
      );
    });

    state = res.isLoading ? const AsyncLoading() : const AsyncData(null);
    return res.value ?? [];
  }
}
