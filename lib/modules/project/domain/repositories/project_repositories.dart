import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';

abstract class ProjectRepo {
  /// Create project + (optional) upload cover/images/icons
  Future<String> addProjectWithUploads({
    required ProjectEntity project,
    XFile? coverFile,
    List<XFile> imageFiles = const [],
    List<XFile> iconFiles = const [],
  });

  /// Read
  Future<List<ProjectEntity>> getAllProjects();
  Future<ProjectEntity?> getProjectById(String id);

  /// Update project + (optional) replace old files with new files
  Future<void> updateProjectWithUploadsReplace({
    required ProjectEntity oldProject,
    required ProjectEntity newProject,
    XFile? newCoverFile,
    List<XFile> newImageFiles = const [],
    List<XFile> newIconFiles = const [],
    bool deleteOldFiles,
  });

  /// Delete project + its files from storage
  Future<void> deleteProjectWithFiles(ProjectEntity project);
}
