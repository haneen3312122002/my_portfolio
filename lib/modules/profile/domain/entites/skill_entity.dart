class SkillEntity {
  final String id;
  final String name;
  final String imageUrl;
  final int proficiency; // 0 - 100
  final List<String> subSkills;
  final String? barColorHex;
  const SkillEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.proficiency,
    required this.subSkills,
    this.barColorHex = '#2196F3', // Default to blue
  });
}
