import 'package:my_portfolio/modules/profile/data/datasources/profile_datasources.dart';
import 'package:my_portfolio/modules/profile/data/models/profile_model.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/modules/profile/domain/repositories/profile_repositories.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileService _service;

  ProfileRepoImpl(this._service);

  @override
  @override
  Future<ProfileEntity> getProfile() {
    return _service.getProfile();
  }

  @override
  @override
  Future<void> upsertProfile(ProfileEntity profile) {
    return _service.upsertProfile(ProfileModel.fromEntity(profile));
  }

  @override
  Future<void> updateProfileFields(Map<String, dynamic> fields) {
    return _service.updateProfileFields(fields);
  }
}
