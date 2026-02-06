import 'package:my_portfolio/modules/profile/domain/entites/skill_entity.dart';

class SkillModel extends SkillEntity {
  const SkillModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.proficiency,
    required super.subSkills,
    super.barColorHex,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      proficiency: (json['proficiency'] as num?)?.toInt() ?? 0,
      subSkills:
          (json['subSkills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      barColorHex: (json['barColorHex'] as String?) ?? '#00C2FF',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'proficiency': proficiency,
      'subSkills': subSkills,
      'barColorHex': barColorHex,
    };
  }

  factory SkillModel.fromEntity(SkillEntity entity) {
    return SkillModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      proficiency: entity.proficiency,
      subSkills: entity.subSkills,
      barColorHex: entity.barColorHex,
    );
  }
  SkillModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? proficiency,
    List<String>? subSkills,
    String? barColorHex,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      proficiency: proficiency ?? this.proficiency,
      subSkills: subSkills ?? this.subSkills,
      barColorHex: barColorHex ?? this.barColorHex,
    );
  }
}
