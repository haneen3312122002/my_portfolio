import 'package:my_portfolio/modules/profile/domain/entites/social_link.dart';

class ProjectEntity {
  final String id;
  final String title;
  final String description;
  final String coverImage;
  final List<SocialItem> links;
  final List<String> projectImages;
  final List<String> projectIcons;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.links,
    required this.projectImages,
    required this.projectIcons,
  });

  ProjectEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? coverImage,
    List<SocialItem>? links,
    List<String>? projectImages,
    List<String>? projectIcons,
  }) {
    return ProjectEntity(
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
