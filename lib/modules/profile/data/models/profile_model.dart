import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/modules/profile/domain/entites/social_link.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    super.id,
    super.name,
    super.phone,
    super.title,
    super.about,
    super.image,

    super.education,
    super.skills,
    super.socialLinks,
  });

  factory ProfileModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return ProfileModel(
      id: snapshot.id,
      name: (data['name'] ?? '') as String,
      phone: (data['phone'] ?? '') as String,
      title: (data['title'] ?? '') as String,
      about: (data['about'] ?? '') as String,
      image: (data['image'] ?? '') as String,
      socialLinks:
          (data['socialLinks'] as List?)
              ?.map((e) => SocialItem.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
      education: (data['education'] ?? '') as String,
      skills: (data['skills'] as List?)?.cast<String>() ?? const [],
    );
  }

  /// Firestore write payload
  Map<String, dynamic> toDocument() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'title': title,
      'about': about,
      'image': image,
      'education': education,
      'skills': skills,
      'socialLinks': socialLinks.map((e) => e.toMap()).toList(),
    };
  }

  /// Optional helper: from entity (useful in RepoImpl)
  factory ProfileModel.fromEntity(ProfileEntity e) {
    return ProfileModel(
      id: e.id,
      name: e.name,
      phone: e.phone,
      title: e.title,
      about: e.about,
      image: e.image,
      education: e.education,
      skills: e.skills,
      socialLinks: e.socialLinks,
    );
  }
}
