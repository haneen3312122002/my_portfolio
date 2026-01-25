import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/profile/data/models/profile_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileService(this._firestore, this._storage);

  static const _collection = 'profile';
  static const _docId = 'main';

  Future<ProfileModel> getProfile() async {
    print('GET PROFILE: start');

    final docRef = _firestore.collection(_collection).doc(_docId);

    try {
      print('GET PROFILE: before get');
      final doc = await docRef.get().timeout(const Duration(seconds: 8));
      print('GET PROFILE: after get exists=${doc.exists}');

      if (!doc.exists) {
        print('GET PROFILE: creating empty');
        final emptyProfile = ProfileModel(id: _docId);

        await docRef.set(emptyProfile.toDocument());
        print('GET PROFILE: created');

        return emptyProfile;
      }

      print('GET PROFILE: returning model');
      return ProfileModel.fromDocument(doc);
    } catch (e, st) {
      print('GET PROFILE: ERROR $e');
      print(st);
      rethrow;
    }
  }

  Future<void> upsertProfile(ProfileModel profile) async {
    await _firestore
        .collection(_collection)
        .doc(_docId)
        .set(profile.toDocument(), SetOptions(merge: true));
  }

  Future<void> updateProfileFields(Map<String, dynamic> fields) async {
    if (fields.isEmpty) return;

    await _firestore.collection(_collection).doc(_docId).update(fields);
  }

  //upload image to storage
  Future<String?> uploadImage(XFile file) async {
    print('..........enter');
    try {
      final response = _storage
          .ref()
          .child('profile_images')
          .child('profile_photo.jpg');
      //upload photo
      final bytes = await file.readAsBytes();
      await response.putData(bytes);
      //get download url
      final url = await response.getDownloadURL();
      //put in profile:
      await updateProfileFields({'image': url});
      return url;
    } catch (e, st) {
      debugPrint('UPLOAD IMAGE ERROR: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  //
  Future<String> uploadSocialIcon({
    required Uint8List bytes,
    required String originalFileName,
    String profileId = 'main',
  }) async {
    print('enter the method');
    final safeName = originalFileName.replaceAll(RegExp(r'\s+'), '_');
    final fileName = 'icon_${DateTime.now().millisecondsSinceEpoch}_$safeName';

    final ref = _storage
        .ref()
        .child('social_icons')
        .child(profileId)
        .child(fileName);
    print('...............before put');
    print('bytes length = ${bytes.length}');
    print('fileName = $originalFileName');

    final task = ref.putData(
      bytes,
      SettableMetadata(
        cacheControl: 'public,max-age=31536000',
        contentType: 'image/jpeg', // جرّبي png حسب الملف
      ),
    );

    // يطبع progress/state
    task.snapshotEvents.listen(
      (s) {
        print('state=${s.state}  ${s.bytesTransferred}/${s.totalBytes}');
      },
      onError: (e) {
        print('snapshotEvents ERROR: $e');
      },
    );

    try {
      // timeout عشان لو علّق ما يضل واقف للأبد
      final snap = await task.timeout(const Duration(seconds: 25));
      print('...............after put state=${snap.state}');

      final url = await ref.getDownloadURL();
      print('downloadUrl=$url');
      return url;
    } catch (e, st) {
      print('UPLOAD ERROR: $e');
      print(st);
      rethrow;
    }
  }
}
