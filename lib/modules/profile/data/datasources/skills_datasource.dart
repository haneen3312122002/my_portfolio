import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:my_portfolio/modules/profile/data/models/skill_model.dart';

class SkillService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  SkillService(this._firestore, this._storage);

  static const _collection = 'skills';

  CollectionReference<Map<String, dynamic>> get _skillsRef =>
      _firestore.collection(_collection);

  // Get all skills (ordered by createdAt ascending)
  Future<List<SkillModel>> getSkills() async {
    try {
      final qs = await _skillsRef
          .orderBy('created_at', descending: false)
          .get()
          .timeout(const Duration(seconds: 8));

      return qs.docs.map((d) {
        final data = d.data();
        data['id'] = data['id'] ?? d.id;
        return SkillModel.fromJson(data);
      }).toList();
    } catch (e, st) {
      debugPrint('GET SKILLS ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  //one run for the function to make migration for the createdAt field for old skills that were created before adding this field
  Future<void> backfillCreatedAt() async {
    final snap = await _skillsRef.get();

    for (final doc in snap.docs) {
      final data = doc.data();

      if (!data.containsKey('createdAt')) {
        await doc.reference.update({'createdAt': FieldValue.serverTimestamp()});
      }
    }
  }

  //  Get one skill
  Future<SkillModel?> getSkillById(String id) async {
    try {
      final doc = await _skillsRef
          .doc(id)
          .get()
          .timeout(const Duration(seconds: 8));
      if (!doc.exists) return null;

      final data = doc.data()!;
      data['id'] = data['id'] ?? doc.id;
      return SkillModel.fromJson(data);
    } catch (e, st) {
      debugPrint('GET SKILL ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<String> upsertSkill(SkillModel skill) async {
    try {
      final id = skill.id.trim();

      //  aDD mode (auto-id)
      if (id.isEmpty) {
        final doc = _skillsRef.doc(); // creates new doc ref with auto-id
        final data = skill.toJson();

        data['id'] = doc.id;
        data['created_at'] = FieldValue.serverTimestamp();

        await doc
            .set(data, SetOptions(merge: true))
            .timeout(const Duration(seconds: 8));

        return doc.id;
      }

      //  UPSERT mode (known id)
      await _skillsRef
          .doc(id)
          .set(skill.toJson(), SetOptions(merge: true))
          .timeout(const Duration(seconds: 8));

      return id;
    } catch (e, st) {
      debugPrint('UPSERT SKILL ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  // update specific fields
  Future<void> updateSkillFields(String id, Map<String, dynamic> fields) async {
    if (fields.isEmpty) return;

    try {
      await _skillsRef
          .doc(id)
          .update(fields)
          .timeout(const Duration(seconds: 8));
    } catch (e, st) {
      debugPrint('UPDATE SKILL FIELDS ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  // Delete skill
  Future<void> deleteSkill(String id) async {
    try {
      await _skillsRef.doc(id).delete().timeout(const Duration(seconds: 8));
    } catch (e, st) {
      debugPrint('DELETE SKILL ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  // Upload skill image and update skill document with the image URL
  Future<String?> uploadSkillImageAndUpdate({
    required String skillId,
    required XFile file,
    String fieldName = 'imageUrl',
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final original = file.name.isNotEmpty ? file.name : 'skill_image';
      final safeName = original.replaceAll(RegExp(r'\s+'), '_');
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$safeName';

      final ref = _storage
          .ref()
          .child('skill_images')
          .child(skillId)
          .child(fileName);

      final task = ref.putData(
        bytes,
        SettableMetadata(
          cacheControl: 'public,max-age=31536000',
          contentType: _guessContentType(original),
        ),
      );

      task.snapshotEvents.listen(
        (s) => debugPrint(
          'SKILL IMG state=${s.state} ${s.bytesTransferred}/${s.totalBytes}',
        ),
        onError: (e) => debugPrint('SKILL IMG snapshotEvents ERROR: $e'),
      );

      await task.timeout(const Duration(seconds: 25));

      final url = await ref.getDownloadURL();

      // update in Firestore
      await updateSkillFields(skillId, {fieldName: url});

      return url;
    } catch (e, st) {
      debugPrint('UPLOAD SKILL IMAGE ERROR: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  // Upload skill image from bytes and update skill document with the image URL
  Future<String?> uploadSkillImageBytesAndUpdate({
    required String skillId,
    required Uint8List bytes,
    required String originalFileName,
    String fieldName = 'imageUrl',
  }) async {
    try {
      final safeName = originalFileName.replaceAll(RegExp(r'\s+'), '_');
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$safeName';

      final ref = _storage
          .ref()
          .child('skill_images')
          .child(skillId)
          .child(fileName);

      await ref
          .putData(
            bytes,
            SettableMetadata(
              cacheControl: 'public,max-age=31536000',
              contentType: _guessContentType(originalFileName),
            ),
          )
          .timeout(const Duration(seconds: 25));

      final url = await ref.getDownloadURL();
      await updateSkillFields(skillId, {fieldName: url});

      return url;
    } catch (e, st) {
      debugPrint('UPLOAD SKILL BYTES ERROR: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  //guess content type based on file extension
  String _guessContentType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    return 'application/octet-stream';
  }
}
