import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_file/cross_file.dart';

import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/domain/usecases/project_usecases.dart';
import 'package:my_portfolio/modules/project/presentation/providers/project_services_providers.dart';

final projectsProvider =
    AsyncNotifierProvider<ProjectsViewModel, List<ProjectEntity>>(
      ProjectsViewModel.new,
    );

class ProjectsViewModel extends AsyncNotifier<List<ProjectEntity>> {
  ProjectUseCase get _useCase => ref.read(usecaseProvider);

  // ====== helpers ======
  Future<List<ProjectEntity>> _fetchAll() => _useCase.getAllProjects();

  @override
  Future<List<ProjectEntity>> build() async {
    return _fetchAll();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAll);
  }

  // ===================== CREATE =====================
  Future<String?> addProject({
    required ProjectEntity project,
    XFile? coverFile,
    List<XFile> imageFiles = const [],
    List<XFile> iconFiles = const [],
  }) async {
    // optional: optimistic loading
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      final id = await _useCase.addProjectWithUploads(
        project: project,
        coverFile: coverFile,
        imageFiles: imageFiles,
        iconFiles: iconFiles,
      );
      // بعد الإضافة: رجّع القائمة من جديد
      final list = await _fetchAll();
      state = AsyncData(list);
      return id;
    });

    // إذا صار خطأ، خليه ينعكس على state
    if (result.hasError) {
      state = AsyncError(result.error!, result.stackTrace!);
      return null;
    }
    return result.value;
  }

  // ===================== UPDATE =====================
  Future<void> updateProject({
    required ProjectEntity oldProject,
    required ProjectEntity newProject,
    XFile? newCoverFile,
    List<XFile> newImageFiles = const [],
    List<XFile> newIconFiles = const [],
    bool deleteOldFiles = true,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _useCase.updateProjectWithUploadsReplace(
        oldProject: oldProject,
        newProject: newProject,
        newCoverFile: newCoverFile,
        newImageFiles: newImageFiles,
        newIconFiles: newIconFiles,
        deleteOldFiles: deleteOldFiles,
      );
      return await _fetchAll();
    });
  }

  // ===================== DELETE =====================
  Future<void> deleteProject(ProjectEntity project) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _useCase.deleteProjectWithFiles(project);
      return await _fetchAll();
    });
  }

  // ===================== READ (اختياري) =====================
  Future<ProjectEntity?> getById(String id) async {
    // هاي ما بتغير state إلا إذا بدك
    return _useCase.getProjectById(id);
  }
}
