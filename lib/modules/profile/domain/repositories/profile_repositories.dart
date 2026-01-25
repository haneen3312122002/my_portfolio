import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';

abstract class ProfileRepo {
  Future<ProfileEntity> getProfile();
  Future<void> upsertProfile(ProfileEntity profile);
  Future<void> updateProfileFields(Map<String, dynamic> fields);
  Future<String?> uploadImage(XFile file);
  Future<String> uploadSocialIcon({
    required Uint8List bytes,
    required String originalFileName,
  });
}
//