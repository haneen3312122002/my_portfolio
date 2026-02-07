import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/modules/profile/data/datasources/skills_datasource.dart';
import 'package:my_portfolio/modules/profile/data/models/skill_model.dart';
import 'package:my_portfolio/modules/profile/domain/entites/skill_entity.dart';
import 'package:my_portfolio/modules/profile/domain/repositories/skill_repo.dart';

class SkillRepoImpl implements SkillRepo {
  final SkillService _service;

  SkillRepoImpl(this._service);

  @override
  Future<List<SkillEntity>> getSkills() {
    return _service.getSkills();
  }

  @override
  Future<SkillEntity?> getSkillById(String id) {
    return _service.getSkillById(id);
  }

  @override
  Future<String> upsertSkill(SkillEntity skill) async {
    final id = await _service.upsertSkill(SkillModel.fromEntity(skill));
    debugPrint('repo--New skill added with id: $id');
    return id;
  }

  @override
  Future<void> updateSkillFields(String id, Map<String, dynamic> fields) {
    return _service.updateSkillFields(id, fields);
  }

  @override
  Future<void> deleteSkill(String id) {
    return _service.deleteSkill(id);
  }

  @override
  Future<String?> uploadSkillImageAndUpdate({
    required String skillId,
    required XFile file,
    String fieldName = 'imageUrl',
  }) {
    return _service.uploadSkillImageAndUpdate(
      skillId: skillId,
      file: file,
      fieldName: fieldName,
    );
  }

  @override
  Future<String?> uploadSkillImageBytesAndUpdate({
    required String skillId,
    required Uint8List bytes,
    required String originalFileName,
    String fieldName = 'imageUrl',
  }) {
    return _service.uploadSkillImageBytesAndUpdate(
      skillId: skillId,
      bytes: bytes,
      originalFileName: originalFileName,
      fieldName: fieldName,
    );
  }
}
