import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/profile/domain/entites/skill_entity.dart';
import 'package:my_portfolio/modules/profile/domain/repositories/skill_repo.dart';

class SkillUseCase {
  final SkillRepo skillRepo;

  SkillUseCase(this.skillRepo);

  Future<List<SkillEntity>> getSkills() {
    return skillRepo.getSkills();
  }

  Future<SkillEntity?> getSkillById(String id) {
    return skillRepo.getSkillById(id);
  }

  Future<void> upsertSkill(SkillEntity skill) {
    return skillRepo.upsertSkill(skill);
  }

  Future<void> updateSkillFields(String id, Map<String, dynamic> fields) {
    return skillRepo.updateSkillFields(id, fields);
  }

  Future<void> deleteSkill(String id) {
    return skillRepo.deleteSkill(id);
  }

  Future<String?> uploadSkillImageAndUpdate({
    required String skillId,
    required XFile file,
    String fieldName = 'imageUrl',
  }) {
    return skillRepo.uploadSkillImageAndUpdate(
      skillId: skillId,
      file: file,
      fieldName: fieldName,
    );
  }

  Future<String?> uploadSkillImageBytesAndUpdate({
    required String skillId,
    required Uint8List bytes,
    required String originalFileName,
    String fieldName = 'imageUrl',
  }) {
    return skillRepo.uploadSkillImageBytesAndUpdate(
      skillId: skillId,
      bytes: bytes,
      originalFileName: originalFileName,
      fieldName: fieldName,
    );
  }
}
