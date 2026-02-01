import 'package:flutter_riverpod/legacy.dart';

final isProjectEditProvider = StateProvider<bool>((ref) => false);

// draft لتجميع تعديلات الفورم قبل الحفظ
final projectDraftProvider = StateProvider<Map<String, dynamic>>((ref) => {});

// لو عندك شاشة تفاصيل وتحتاجي تعرفي أي مشروع محدد
final selectedProjectIdProvider = StateProvider<String?>((ref) => null);
