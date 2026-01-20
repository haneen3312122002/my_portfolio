import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    super.id,
    super.name,
    super.phone,
    super.email,
    super.title,
    super.about,
    super.image,
    super.github,
    super.linkedin,
    super.education,
    super.skills,
  });

  factory ProfileModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return ProfileModel(
      id: snapshot.id,
      name: (data['name'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      phone: (data['phone'] ?? '') as String,
      title: (data['title'] ?? '') as String,
      about: (data['about'] ?? '') as String,
      image: (data['image'] ?? '') as String,
      github: (data['github'] ?? '') as String,
      linkedin: (data['linkedin'] ?? '') as String,
      education: (data['education'] ?? '') as String,
      skills: (data['skills'] as List?)?.cast<String>() ?? const [],
    );
  }

  /// Firestore write payload
  Map<String, dynamic> toDocument() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'title': title,
      'about': about,
      'image': image,
      'github': github,
      'linkedin': linkedin,
      'education': education,
      'skills': skills,
    };
  }

  /// Optional helper: from entity (useful in RepoImpl)
  factory ProfileModel.fromEntity(ProfileEntity e) {
    return ProfileModel(
      id: e.id,
      name: e.name,
      email: e.email,
      phone: e.phone,
      title: e.title,
      about: e.about,
      image: e.image,
      github: e.github,
      linkedin: e.linkedin,
      education: e.education,
      skills: e.skills,
    );
  }
}
