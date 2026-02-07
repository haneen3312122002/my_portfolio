import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/profile/domain/entites/skill_entity.dart';

abstract class SkillRepo {
  Future<List<SkillEntity>> getSkills();
  Future<SkillEntity?> getSkillById(String id);

  Future<String> upsertSkill(SkillEntity skill);
  Future<void> updateSkillFields(String id, Map<String, dynamic> fields);
  Future<void> deleteSkill(String id);

  /// ترفع الصورة + تعمل update داخل skill doc + ترجع الرابط
  Future<String?> uploadSkillImageAndUpdate({
    required String skillId,
    required XFile file,
    String fieldName,
  });

  /// (اختياري للويب) bytes
  Future<String?> uploadSkillImageBytesAndUpdate({
    required String skillId,
    required Uint8List bytes,
    required String originalFileName,
    String fieldName,
  });
}
