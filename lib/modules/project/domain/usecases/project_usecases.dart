import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/domain/repositories/project_repositories.dart';

class ProjectUseCase {
  final ProjectRepo _repo;

  ProjectUseCase(this._repo);

  // ===================== CREATE =====================

  Future<String> addProjectWithUploads({
    required ProjectEntity project,
    XFile? coverFile,
    List<XFile> imageFiles = const [],
    List<XFile> iconFiles = const [],
  }) {
    return _repo.addProjectWithUploads(
      project: project,
      coverFile: coverFile,
      imageFiles: imageFiles,
      iconFiles: iconFiles,
    );
  }

  // ===================== READ =====================

  Future<List<ProjectEntity>> getAllProjects() {
    return _repo.getAllProjects();
  }

  Future<ProjectEntity?> getProjectById(String id) {
    return _repo.getProjectById(id);
  }

  // ===================== UPDATE =====================

  Future<void> updateProjectWithUploadsReplace({
    required ProjectEntity oldProject,
    required ProjectEntity newProject,
    XFile? newCoverFile,
    List<XFile> newImageFiles = const [],
    List<XFile> newIconFiles = const [],
    bool deleteOldFiles = true,
  }) {
    return _repo.updateProjectWithUploadsReplace(
      oldProject: oldProject,
      newProject: newProject,
      newCoverFile: newCoverFile,
      newImageFiles: newImageFiles,
      newIconFiles: newIconFiles,
      deleteOldFiles: deleteOldFiles,
    );
  }

  // ===================== DELETE =====================

  Future<void> deleteProjectWithFiles(ProjectEntity project) {
    return _repo.deleteProjectWithFiles(project);
  }

  // ✅ Upload cover only
  Future<String> uploadProjectCover({
    required String projectId,
    required XFile cover,
  }) {
    return _repo.uploadProjectCover(projectId: projectId, cover: cover);
  }

  // ✅ Upload images/icons only
  Future<List<String>> uploadProjectMedia({
    required String projectId,
    required List<XFile> files,
    required String folderName,
  }) {
    return _repo.uploadProjectMedia(
      projectId: projectId,
      files: files,
      folderName: folderName,
    );
  }
}
