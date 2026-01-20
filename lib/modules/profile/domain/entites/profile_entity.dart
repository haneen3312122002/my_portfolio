class ProfileEntity {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String title;
  final String about;
  final String image;
  final String github;
  final String linkedin;
  final String education;
  final List<String> skills;

  const ProfileEntity({
    this.id = 'main',
    this.name = '',
    this.phone = '',
    this.email = '',
    this.title = '',
    this.about = '',
    this.image = '',
    this.github = '',
    this.linkedin = '',
    this.education = '',
    this.skills = const [],
  });
}
