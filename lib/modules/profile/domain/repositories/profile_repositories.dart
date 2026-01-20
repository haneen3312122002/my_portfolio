import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';

abstract class ProfileRepo {
  Future<ProfileEntity> getProfile();
  Future<void> upsertProfile(ProfileEntity profile);
  Future<void> updateProfileFields(Map<String, dynamic> fields);
}
