class SocialItem {
  final String url; // رابط السوشيال (GitHub, LinkedIn...)
  final String? iconUrl; // رابط الأيقونة من Firebase Storage
  final String? name; // اسم اختياري (GitHub, Email...)
  final int? iconCodePoint; // لو استخدمتي IconData بدل صورة

  const SocialItem({
    required this.url,
    this.iconUrl,
    this.name,
    this.iconCodePoint,
  });

  /// Firestore → App
  factory SocialItem.fromMap(Map<String, dynamic> map) {
    return SocialItem(
      url: map['url'] as String? ?? '',
      iconUrl: map['iconUrl'] as String?,
      name: map['name'] as String?,
      iconCodePoint: map['icon'] is int ? map['icon'] as int : null,
    );
  }

  /// App → Firestore
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      if (iconUrl != null && iconUrl!.isNotEmpty) 'iconUrl': iconUrl,
      if (name != null && name!.isNotEmpty) 'name': name,
      if (iconCodePoint != null) 'icon': iconCodePoint,
    };
  }
}
