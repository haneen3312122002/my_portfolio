import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/domain/usecases/project_usecases.dart';
import 'package:my_portfolio/modules/project/presentation/providers/project_services_providers.dart';

/// Provider that exposes the projects state to the UI.
/// The state is an AsyncValue<List<ProjectEntity>>:
/// - loading: while fetching / performing CRUD
/// - error: if something fails
/// - data: the latest list of projects
final projectsProvider =
    AsyncNotifierProvider<ProjectsViewModel, List<ProjectEntity>>(
      ProjectsViewModel.new,
    );

/// ViewModel responsible for managing the projects list and CRUD operations.
/// It talks to the Domain layer via ProjectUseCase (not directly to Firestore/Storage).
///
/// UI usage (typical):
/// - ref.watch(projectsProvider) to render loading/error/data
/// - ref.read(projectsProvider.notifier).addProject/updateProject/deleteProject for actions
class ProjectsViewModel extends AsyncNotifier<List<ProjectEntity>> {
  /// Read the use case from DI/provider.
  /// We keep it as a getter so it always reads the latest instance from Riverpod.
  ProjectUseCase get _useCase => ref.read(usecaseProvider);

  // ------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------

  /// Fetches the full projects list from backend (Firestore through use case).
  Future<List<ProjectEntity>> _fetchAll() => _useCase.getAllProjects();

  /// Called automatically by Riverpod when the provider is first created
  /// (and when it needs to rebuild).
  ///
  /// Returning _fetchAll() here means:
  /// "As soon as the screen watches projectsProvider, load projects."
  @override
  Future<List<ProjectEntity>> build() async {
    return _fetchAll();
  }

  /// Manually re-fetch projects (pull-to-refresh, retry button, etc.).
  /// We set loading first so UI can show a spinner.
  Future<void> refresh() async {
    state = const AsyncLoading();

    // guard() wraps exceptions into AsyncError instead of crashing the app
    state = await AsyncValue.guard(_fetchAll);
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------

  /// Creates a new project and uploads optional media files (cover/images/icons).
  ///
  /// Flow:
  /// 1) Set state to loading
  /// 2) Call use case to create + upload
  /// 3) Re-fetch list so UI shows the new project immediately
  ///
  /// Returns the created project ID if success, otherwise null.
  Future<String?> addProject({
    required ProjectEntity project,
    XFile? coverFile,
    List<XFile> imageFiles = const [],
    List<XFile> iconFiles = const [],
  }) async {
    // Mark the whole list as "busy" while saving
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      // Create project + upload media through domain layer
      final id = await _useCase.addProjectWithUploads(
        project: project,
        coverFile: coverFile,
        imageFiles: imageFiles,
        iconFiles: iconFiles,
      );

      // After creation, refresh the list so UI stays in sync
      final list = await _fetchAll();
      state = AsyncData(list);

      return id;
    });

    // If something failed, expose the error to UI
    if (result.hasError) {
      state = AsyncError(result.error!, result.stackTrace!);
      return null;
    }

    return result.value;
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------

  /// Updates an existing project and optionally replaces its media.
  ///
  /// Parameters:
  /// - oldProject/newProject: used to know what changed
  /// - newCoverFile/newImageFiles/newIconFiles: provide only what you want to replace
  /// - deleteOldFiles: when true, old storage files are removed to avoid orphan files
  ///
  /// After updating, we re-fetch the list to reflect changes in UI.
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

      // Keep UI list updated after the edit
      return await _fetchAll();
    });
  }

  // ------------------------------------------------------------
  // DELETE
  // ------------------------------------------------------------

  /// Deletes a project and its associated storage files (if implemented in use case/service).
  /// After deletion, we re-fetch the list so the removed project disappears from UI.
  Future<void> deleteProject(ProjectEntity project) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _useCase.deleteProjectWithFiles(project);
      return await _fetchAll();
    });
  }

  // ------------------------------------------------------------
  // READ (Optional)
  // ------------------------------------------------------------

  /// Fetches a single project by id.
  /// This does NOT modify the list state by default.
  /// Useful for details page if you want to load one project only.
  Future<ProjectEntity?> getById(String id) async {
    return _useCase.getProjectById(id);
  }
}
