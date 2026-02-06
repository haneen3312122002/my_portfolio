import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/profile_service_provider.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';

final profileProvider = AsyncNotifierProvider<ProfileViewModel, ProfileEntity>(
  ProfileViewModel.new,
);

class ProfileViewModel extends AsyncNotifier<ProfileEntity> {
  Future<ProfileEntity> _fetchProfile() {
    final useCase = ref.read(profileUseCaseProvider);
    return useCase.getProfile();
  }

  @override
  Future<ProfileEntity> build() async {
    //return _fetchProfile();
    final useCase = ref.read(profileUseCaseProvider);
    final result = await useCase.getProfile();
    return result;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchProfile);
  }

  Future<void> updateProfileFields(Map<String, dynamic> fields) async {
    state = const AsyncLoading(); // الصفحة كلها Loading
    //insted of try catch
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(profileUseCaseProvider);
      await useCase.updateProfileFields(fields);
      return await _fetchProfile();
    });
  }

  Future<void> onSave() async {
    final isEditVm = ref.read(isEditProvider.notifier);
    final draft = ref.read(profileDraftProvider);

    if (draft.isEmpty) {
      isEditVm.state = false;
      return;
    }

    final fields = <String, dynamic>{};

    // about
    final about = draft['about'];
    if (about != null) fields['about'] = about;

    // education
    final education = draft['education'];
    if (education != null) fields['education'] = education;

    // skills (robust)
    if (draft.containsKey('skills')) {
      final raw = draft['skills'];

      // ممكن تكون String أو List<String>
      final List<String> parsed = (raw is List)
          ? raw
                .map((e) => e.toString().trim())
                .where((e) => e.isNotEmpty)
                .toList()
          : raw
                .toString()
                .split('\n')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();

      fields['skills'] = parsed;
    }

    // name
    final name = draft['name'];
    if (name != null) fields['name'] = name;

    // image
    final image = draft['image'];
    if (image != null) fields['image'] = image;

    if (fields.isEmpty) {
      // ما في إشي فعلي ينحفظ
      isEditVm.state = false;
      return;
    }

    try {
      debugPrint('PROFILE onSave fields => $fields');

      await updateProfileFields(fields);

      // صفّر المسودة واطلع من edit
      ref.read(profileDraftProvider.notifier).state = {};
      isEditVm.state = false;

      // مهم: عشان يعيد جلب البروفايل (إذا getProfile مش stream)
      ref.invalidate(profileProvider);
    } catch (e, st) {
      debugPrint('PROFILE onSave ERROR => $e');
      debugPrintStack(stackTrace: st);
      rethrow; // خلي UI (ErrorMapper via ref.listen) يعرض الرسالة
    }
  }

  void onEdit() {
    final isEdit = ref.read(isEditProvider);
    final isEditVm = ref.read(isEditProvider.notifier);
    isEditVm.state = !isEdit;
  }
}
