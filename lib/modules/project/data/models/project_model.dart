import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio/modules/profile/domain/entites/social_link.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.description,
    required super.coverImage,
    required super.links,
    required super.projectImages,
    required super.projectIcons,
  });

  factory ProjectModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data() ?? {};
    return ProjectModel(
      id: doc.id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      coverImage: json['coverImage'] as String? ?? '',
      links:
          (json['links'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(SocialItem.fromMap)
              .toList() ??
          const [],

      projectImages:
          (json['projectImages'] as List<dynamic>?)
              ?.map((e) => (e ?? '').toString())
              .where((e) => e.isNotEmpty)
              .toList() ??
          const [],
      projectIcons:
          (json['projectIcons'] as List<dynamic>?)
              ?.map((e) => (e ?? '').toString())
              .where((e) => e.isNotEmpty)
              .toList() ??
          const [],
    );
  }

  factory ProjectModel.fromEntity(ProjectEntity entity) => ProjectModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    coverImage: entity.coverImage,
    links: entity.links,
    projectImages: entity.projectImages,
    projectIcons: entity.projectIcons,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'coverImage': coverImage,
    'links': links.map((e) => e.toMap()).toList(),
    'projectImages': projectImages,
    'projectIcons': projectIcons,
  };

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? coverImage,
    List<SocialItem>? links,
    List<String>? projectImages,
    List<String>? projectIcons,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      links: links ?? this.links,
      projectImages: projectImages ?? this.projectImages,
      projectIcons: projectIcons ?? this.projectIcons,
    );
  }
}
