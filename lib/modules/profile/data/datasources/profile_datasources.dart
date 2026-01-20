import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_portfolio/modules/profile/data/models/profile_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileService(this._firestore, this._storage);

  static const _collection = 'profile';
  static const _docId = 'main';

  Future<ProfileModel> getProfile() async {
    final ref = _firestore.collection(_collection).doc(_docId);
    final doc = await ref.get();

    if (!doc.exists) {
      final emptyProfile = ProfileModel(
        id: _docId,
        name: '',
        email: '',
        phone: '',
        title: '',
        about: '',
        image: '',
        github: '',
        linkedin: '',
        education: '',
        skills: [],
      );

      await ref.set(emptyProfile.toDocument());
      return emptyProfile;
    }

    return ProfileModel.fromDocument(doc);
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
}
