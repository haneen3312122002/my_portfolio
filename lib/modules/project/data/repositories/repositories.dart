import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/project/data/datasources/projects_datasources.dart';
import 'package:my_portfolio/modules/project/data/models/project_model.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/domain/repositories/project_repositories.dart';

/// Repository implementation (Data layer).
/// This class is the "bridge" between:
/// - Domain layer (Entities + Repository interface)
/// - Data layer (Firestore/Storage service)
///
/// The goal is to keep the domain clean:
/// UI/ViewModels talk to the repository interface (ProjectRepo),
/// and this implementation translates the domain entity into data models
/// then delegates the real work to ProjectService.
class ProjectRepoImpl implements ProjectRepo {
  /// Low-level service that actually talks to Firestore + Storage
  final ProjectService _service;

  ProjectRepoImpl(this._service);

  @override
  Future<String> addProjectWithUploads({
    required ProjectEntity project,
    XFile? coverFile,
    List<XFile> imageFiles = const [],
    List<XFile> iconFiles = const [],
  }) {
    // Convert Domain entity -> Data model before sending to the service
    return _service.addProjectWithUploads(
      project: ProjectModel.fromEntity(project),
      coverFile: coverFile,
      imageFiles: imageFiles,
      iconFiles: iconFiles,
    );
  }

  @override
  Future<List<ProjectEntity>> getAllProjects() async {
    // Service returns models from Firestore
    final models = await _service.getAllProjects();

    // Returning as entities is fine because ProjectModel extends ProjectEntity
    // (So the caller doesn't need to know about models)
    return models;
  }

  @override
  Future<ProjectEntity?> getProjectById(String id) async {
    // Fetch from service, could be null if document doesn't exist
    final model = await _service.getProjectById(id);

    // Returning as entity keeps domain/API consistent
    return model;
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
    // Convert both old/new entities to models because service expects models
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
    // Convert entity -> model then let service delete files + doc
    return _service.deleteProjectWithFiles(ProjectModel.fromEntity(project));
  }

  @override
  Future<String> uploadProjectCover({
    required String projectId,
    required XFile cover,
  }) {
    // Expose service helper method through repository
    return _service.uploadCover(projectId: projectId, cover: cover);
  }

  @override
  Future<List<String>> uploadProjectMedia({
    required String projectId,
    required List<XFile> files,
    required String folderName,
  }) {
    // Generic uploader for images/icons (depends on folderName)
    return _service.uploadMany(
      projectId: projectId,
      files: files,
      folderName: folderName,
    );
  }
}
