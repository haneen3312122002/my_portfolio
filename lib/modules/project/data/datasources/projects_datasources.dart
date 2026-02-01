import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_portfolio/core/helpers/upload_file.dart';
import 'package:my_portfolio/modules/project/data/models/project_model.dart';

class ProjectService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProjectService(this._firestore, this._storage);

  static const _collection = 'projects';

  late final StorageUploader _uploader = StorageUploader(_storage);

  Future<String> addProjectWithUploads({
    required ProjectModel project,
    XFile? coverFile,
    List<XFile> imageFiles = const [],
    List<XFile> iconFiles = const [],
  }) async {
    try {
      final docRef = _firestore.collection(_collection).doc();
      final projectId = docRef.id;

      String coverUrl = project.coverImage;
      List<String> imagesUrls = project.projectImages;
      List<String> iconsUrls = project.projectIcons;

      if (coverFile != null) {
        coverUrl = await uploadCover(projectId: projectId, cover: coverFile);
      }

      if (imageFiles.isNotEmpty) {
        imagesUrls = await uploadMany(
          projectId: projectId,
          files: imageFiles,
          folderName: 'images',
        );
      }

      if (iconFiles.isNotEmpty) {
        iconsUrls = await uploadMany(
          projectId: projectId,
          files: iconFiles,
          folderName: 'icons',
        );
      }

      final toSave = project.copyWith(
        id: projectId,
        coverImage: coverUrl,
        projectImages: imagesUrls,
        projectIcons: iconsUrls,
      );

      await docRef.set({
        ...toSave.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return projectId;
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

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

  Future<void> updateProjectWithUploadsReplace({
    required ProjectModel oldProject,
    required ProjectModel newProject,
    XFile? newCoverFile, // إذا بدك تغيّري الكفر
    List<XFile> newImageFiles = const [], // إذا بدك تغيّري صور المشروع
    List<XFile> newIconFiles = const [], // إذا بدك تغيّري الأيقونات
    bool deleteOldFiles = true, // لو بدك يحذف القديم من Storage
  }) async {
    try {
      //get the old p[roject id
      final projectId = oldProject.id;
      //get the images urls of old project
      String coverUrl = oldProject.coverImage;
      List<String> imagesUrls = oldProject.projectImages;
      List<String> iconsUrls = oldProject.projectIcons;

      if (newCoverFile != null) {
        //upload new cover
        coverUrl = await uploadCover(projectId: projectId, cover: newCoverFile);
      }

      if (newImageFiles.isNotEmpty) {
        imagesUrls = await uploadMany(
          projectId: projectId,
          files: newImageFiles,
          folderName: 'images',
        );
      }

      if (newIconFiles.isNotEmpty) {
        iconsUrls = await uploadMany(
          projectId: projectId,
          files: newIconFiles,
          folderName: 'icons',
        );
      }

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

      final toUpdate = newProject.copyWith(
        id: projectId,
        coverImage: coverUrl,
        projectImages: imagesUrls,
        projectIcons: iconsUrls,
      );

      await _firestore.collection(_collection).doc(projectId).update({
        ...toUpdate.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<void> deleteProjectWithFiles(ProjectModel project) async {
    try {
      // احذف الملفات (إذا موجودة)
      if (project.coverImage.isNotEmpty) {
        await _deleteByUrl(project.coverImage);
      }

      for (final url in project.projectImages) {
        if (url.isNotEmpty) await _deleteByUrl(url);
      }

      for (final url in project.projectIcons) {
        if (url.isNotEmpty) await _deleteByUrl(url);
      }

      // بعدين احذف الدوك
      await _firestore.collection(_collection).doc(project.id).delete();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<ProjectModel?> getProjectById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      return ProjectModel.fromDoc(doc);
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<String> uploadCover({
    required String projectId,
    required XFile cover,
  }) async {
    final fileName =
        'cover_${DateTime.now().millisecondsSinceEpoch}_${cover.name}';
    final path = 'projects/$projectId/cover/$fileName';
    return _uploader.uploadImageXFile(file: cover, path: path);
  }

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

  //delete project images and icons from storage
  Future<void> _deleteByUrl(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // تجاهلي الخطأ عشان ما يفشل التحديث إذا الحذف ما زبط
    }
  }
}
