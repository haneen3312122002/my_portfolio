import 'package:my_portfolio/modules/profile/domain/entites/social_link.dart';

class ProfileEntity {
  final String id;
  final String name;
  final String phone;

  final String title;
  final String about;
  final String image;
  final List<SocialItem> socialLinks;
  final String education;
  final List<String> skills;

  const ProfileEntity({
    this.id = 'main',
    this.name = '',
    this.phone = '',
    this.title = '',
    this.about = '',
    this.image = '',
    this.education = '',
    this.skills = const [],
    this.socialLinks = const [],
  });
}
