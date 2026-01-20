import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/modules/profile/domain/repositories/profile_repositories.dart';

class ProfileUseCase {
  final ProfileRepo profileRepo;

  ProfileUseCase(this.profileRepo);

  Future<ProfileEntity> getProfile() {
    return profileRepo.getProfile();
  }

  Future<void> upsertProfile(ProfileEntity profile) {
    return profileRepo.upsertProfile(profile);
  }

  Future<void> updateProfileFields(Map<String, dynamic> fields) {
    return profileRepo.updateProfileFields(fields);
  }
}
