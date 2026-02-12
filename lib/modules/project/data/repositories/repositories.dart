import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/project/data/datasources/projects_datasources.dart';
import 'package:my_portfolio/modules/project/data/models/project_model.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/domain/repositories/project_repositories.dart';

class ProjectRepoImpl implements ProjectRepo {
  final ProjectService _service;

  ProjectRepoImpl(this._service);

  @override
  Future<String> addProjectWithUploads({
    required ProjectEntity project,
    XFile? coverFile,
    List<XFile> imageFiles = const [],
    List<XFile> iconFiles = const [],
  }) {
    return _service.addProjectWithUploads(
      project: ProjectModel.fromEntity(project),
      coverFile: coverFile,
      imageFiles: imageFiles,
      iconFiles: iconFiles,
    );
  }

  @override
  Future<List<ProjectEntity>> getAllProjects() async {
    final models = await _service.getAllProjects();
    return models; // ProjectModel extends ProjectEntity
  }

  @override
  Future<ProjectEntity?> getProjectById(String id) async {
    final model = await _service.getProjectById(id);
    return model; // ممكن null
  }

  @override
  Future<void> updateProjectWithUploadsReplace({
    required ProjectEntity oldProject,
    required ProjectEntity newProject,
    XFile? newCoverFile,
    List<XFile> newImageFiles = const [],
    List<XFile> newIconFiles = const [],
    bool deleteOldFiles = true,
  }) {
    return _service.updateProjectWithUploadsReplace(
      oldProject: ProjectModel.fromEntity(oldProject),
      newProject: ProjectModel.fromEntity(newProject),
      newCoverFile: newCoverFile,
      newImageFiles: newImageFiles,
      newIconFiles: newIconFiles,
      deleteOldFiles: deleteOldFiles,
    );
  }

  @override
  Future<void> deleteProjectWithFiles(ProjectEntity project) {
    return _service.deleteProjectWithFiles(ProjectModel.fromEntity(project));
  }

  @override
  Future<String> uploadProjectCover({
    required String projectId,
    required XFile cover,
  }) {
    return _service.uploadCover(projectId: projectId, cover: cover);
  }

  @override
  Future<List<String>> uploadProjectMedia({
    required String projectId,
    required List<XFile> files,
    required String folderName,
  }) {
    return _service.uploadMany(
      projectId: projectId,
      files: files,
      folderName: folderName,
    );
  }
}
