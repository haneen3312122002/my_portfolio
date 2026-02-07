import 'dart:async';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_portfolio/modules/profile/domain/entites/skill_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/skills_providers.dart';

final skillsProvider =
    AsyncNotifierProvider<SkillsViewModel, List<SkillEntity>>(
      SkillsViewModel.new,
    );

class SkillsViewModel extends AsyncNotifier<List<SkillEntity>> {
  Future<List<SkillEntity>> _fetchSkills() {
    final useCase = ref.read(skillUseCaseProvider);
    return useCase.getSkills();
  }

  @override
  Future<List<SkillEntity>> build() async {
    final useCase = ref.read(skillUseCaseProvider);
    final result = await useCase.getSkills();
    return result;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchSkills);
  }

  /// ✅ Upsert (Add أو Update)
  Future<String> upsertSkill(SkillEntity skill) async {
    state = const AsyncLoading();

    String newId = '';

    state = await AsyncValue.guard(() async {
      final useCase = ref.read(skillUseCaseProvider);
      debugPrint(
        '[VM] upsertSkill called. incoming id="${skill.id}" name="${skill.name}"',
      );
      newId = await useCase.upsertSkill(skill);
      debugPrint('[VM] upsertSkill returned id="$newId"');

      return await _fetchSkills();
    });
    debugPrint('vm--New skill added with id: $newId');

    return newId;
  }

  /// ✅ Update fields (لو بدك تعديل جزئي)
  Future<void> updateSkillFields(String id, Map<String, dynamic> fields) async {
    if (fields.isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(skillUseCaseProvider);
      await useCase.updateSkillFields(id, fields);
      return await _fetchSkills();
    });
  }

  /// ✅ Delete
  Future<void> deleteSkill(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(skillUseCaseProvider);
      await useCase.deleteSkill(id);
      return await _fetchSkills();
    });
  }
}
