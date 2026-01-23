import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/profile_service_provider.dart';

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
}
