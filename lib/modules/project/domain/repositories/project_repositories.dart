import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';

abstract class ProjectRepo {
  Future<String> addProjectWithUploads({
    required ProjectEntity project,
    XFile? coverFile,
    List<XFile> imageFiles,
    List<XFile> iconFiles,
  });

  Future<List<ProjectEntity>> getAllProjects();
  Future<ProjectEntity?> getProjectById(String id);

  Future<void> updateProjectWithUploadsReplace({
    required ProjectEntity oldProject,
    required ProjectEntity newProject,
    XFile? newCoverFile,
    List<XFile> newImageFiles,
    List<XFile> newIconFiles,
    bool deleteOldFiles,
  });

  Future<void> deleteProjectWithFiles(ProjectEntity project);

  // ✅ NEW: media upload only
  Future<String> uploadProjectCover({
    required String projectId,
    required XFile cover,
  });

  Future<List<String>> uploadProjectMedia({
    required String projectId,
    required List<XFile> files,
    required String folderName, // 'images' أو 'icons'
  });
}
