import 'package:flutter_riverpod/legacy.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';

// draft لتجميع تعديلات الفورم قبل الحفظ
final projectDraftProvider = StateProvider<Map<String, dynamic>>((ref) => {});
//TODO : can be used to store the selected project id for detailes page, but i will use the whole project entity for more flexibility
//final selectedProjectIdProvider = StateProvider<String?>((ref) => null);
final editingProjectProvider = StateProvider<ProjectEntity?>((ref) => null);
