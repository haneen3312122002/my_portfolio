import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_portfolio/core/helpers/upload_file.dart';
import 'package:my_portfolio/modules/project/data/models/project_model.dart';

/// Service responsible for handling all project-related
/// operations including:
/// - Firestore CRUD
/// - Uploading files to Firebase Storage
/// - Deleting associated files
class ProjectService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProjectService(this._firestore, this._storage);

  /// Firestore collection name
  static const _collection = 'projects';

  /// Helper class that handles uploading logic to Storage
  late final StorageUploader _uploader = StorageUploader(_storage);

  /// ------------------------------------------------------------
  /// CREATE PROJECT
  /// ------------------------------------------------------------
  /// Creates a new project document and uploads any provided files.
  /// - Generates a new document ID first
  /// - Uploads cover/images/icons if provided
  /// - Saves URLs in Firestore
  /// - Adds server timestamp for creation
  Future<String> addProjectWithUploads({
    required ProjectModel project,
    XFile? coverFile,
    List<XFile> imageFiles = const [],
    List<XFile> iconFiles = const [],
  }) async {
    try {
      // Generate a new Firestore document reference
      final docRef = _firestore.collection(_collection).doc();
      final projectId = docRef.id;

      // Start with existing URLs (in case project already has defaults)
      String coverUrl = project.coverImage;
      List<String> imagesUrls = project.projectImages;
      List<String> iconsUrls = project.projectIcons;

      // Upload cover if provided
      if (coverFile != null) {
        coverUrl = await uploadCover(projectId: projectId, cover: coverFile);
      }

      // Upload project images if provided
      if (imageFiles.isNotEmpty) {
        imagesUrls = await uploadMany(
          projectId: projectId,
          files: imageFiles,
          folderName: 'images',
        );
      }

      // Upload project icons if provided
      if (iconFiles.isNotEmpty) {
        iconsUrls = await uploadMany(
          projectId: projectId,
          files: iconFiles,
          folderName: 'icons',
        );
      }

      // Create final project object with generated ID and uploaded URLs
      final toSave = project.copyWith(
        id: projectId,
        coverImage: coverUrl,
        projectImages: imagesUrls,
        projectIcons: iconsUrls,
      );

      // Save to Firestore with server timestamp
      await docRef.set({
        ...toSave.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return projectId;
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  /// ------------------------------------------------------------
  /// READ ALL PROJECTS
  /// ------------------------------------------------------------
  /// Retrieves all projects ordered by creation date (newest first)
  Future<List<ProjectModel>> getAllProjects() async {
    try {
      final snap = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs.map(ProjectModel.fromDoc).toList();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  /// ------------------------------------------------------------
  /// UPDATE PROJECT (Replace Mode)
  /// ------------------------------------------------------------
  /// Replaces old files only if new ones are provided.
  /// Optionally deletes old files from Storage.
  Future<void> updateProjectWithUploadsReplace({
    required ProjectModel oldProject,
    required ProjectModel newProject,
    XFile? newCoverFile,
    List<XFile> newImageFiles = const [],
    List<XFile> newIconFiles = const [],
    bool deleteOldFiles = true,
  }) async {
    try {
      final projectId = oldProject.id;

      // Start from old URLs
      String coverUrl = oldProject.coverImage;
      List<String> imagesUrls = oldProject.projectImages;
      List<String> iconsUrls = oldProject.projectIcons;

      // Upload new cover if changed
      if (newCoverFile != null) {
        coverUrl = await uploadCover(projectId: projectId, cover: newCoverFile);
      }

      // Upload new images if changed
      if (newImageFiles.isNotEmpty) {
        imagesUrls = await uploadMany(
          projectId: projectId,
          files: newImageFiles,
          folderName: 'images',
        );
      }

      // Upload new icons if changed
      if (newIconFiles.isNotEmpty) {
        iconsUrls = await uploadMany(
          projectId: projectId,
          files: newIconFiles,
          folderName: 'icons',
        );
      }

      /// Delete old files from Storage if replacement happened
      /// This prevents orphan files and storage waste
      if (deleteOldFiles) {
        if (newCoverFile != null && oldProject.coverImage.isNotEmpty) {
          await _deleteByUrl(oldProject.coverImage);
        }

        if (newImageFiles.isNotEmpty && oldProject.projectImages.isNotEmpty) {
          for (final url in oldProject.projectImages) {
            if (url.isNotEmpty) await _deleteByUrl(url);
          }
        }

        if (newIconFiles.isNotEmpty && oldProject.projectIcons.isNotEmpty) {
          for (final url in oldProject.projectIcons) {
            if (url.isNotEmpty) await _deleteByUrl(url);
          }
        }
      }

      // Prepare updated object
      final toUpdate = newProject.copyWith(
        id: projectId,
        coverImage: coverUrl,
        projectImages: imagesUrls,
        projectIcons: iconsUrls,
      );

      // Update Firestore document
      await _firestore.collection(_collection).doc(projectId).update({
        ...toUpdate.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  /// ------------------------------------------------------------
  /// DELETE PROJECT
  /// ------------------------------------------------------------
  /// Deletes:
  /// 1. All related Storage files
  /// 2. Firestore document
  Future<void> deleteProjectWithFiles(ProjectModel project) async {
    try {
      if (project.coverImage.isNotEmpty) {
        await _deleteByUrl(project.coverImage);
      }

      for (final url in project.projectImages) {
        if (url.isNotEmpty) await _deleteByUrl(url);
      }

      for (final url in project.projectIcons) {
        if (url.isNotEmpty) await _deleteByUrl(url);
      }

      // Finally delete Firestore document
      await _firestore.collection(_collection).doc(project.id).delete();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  /// ------------------------------------------------------------
  /// GET PROJECT BY ID
  /// ------------------------------------------------------------
  /// Returns null if project doesn't exist
  Future<ProjectModel?> getProjectById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      return ProjectModel.fromDoc(doc);
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  /// ------------------------------------------------------------
  /// Upload single cover file
  /// ------------------------------------------------------------
  Future<String> uploadCover({
    required String projectId,
    required XFile cover,
  }) async {
    // Unique file name to prevent overwriting
    final fileName =
        'cover_${DateTime.now().millisecondsSinceEpoch}_${cover.name}';

    final path = 'projects/$projectId/cover/$fileName';

    return _uploader.uploadImageXFile(file: cover, path: path);
  }

  /// ------------------------------------------------------------
  /// Upload multiple files (images or icons)
  /// ------------------------------------------------------------
  Future<List<String>> uploadMany({
    required String projectId,
    required List<XFile> files,
    required String folderName,
  }) async {
    final urls = <String>[];

    for (final f in files) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${f.name}';
      final path = 'projects/$projectId/$folderName/$fileName';

      final url = await _uploader.uploadImageXFile(file: f, path: path);
      urls.add(url);
    }

    return urls;
  }

  /// ------------------------------------------------------------
  /// Deletes file from Firebase Storage using its download URL
  /// Silently ignores errors to avoid breaking main flow
  /// ------------------------------------------------------------
  Future<void> _deleteByUrl(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // Ignore deletion errors intentionally
    }
  }
}
