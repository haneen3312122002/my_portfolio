import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/infrastructure/firebase/firebase_providers.dart';

import 'package:my_portfolio/modules/profile/data/datasources/skills_datasource.dart';
import 'package:my_portfolio/modules/profile/data/repositories/skill_repo_impl.dart';
import 'package:my_portfolio/modules/profile/domain/repositories/skill_repo.dart';
import 'package:my_portfolio/modules/profile/domain/usecases/skill_usecase.dart';

final skillServiceProvider = Provider<SkillService>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final storage = ref.watch(firebaseStorageProvider);
  return SkillService(firestore, storage);
});

final skillRepoProvider = Provider<SkillRepo>((ref) {
  final service = ref.watch(skillServiceProvider);
  return SkillRepoImpl(service);
});

final skillUseCaseProvider = Provider<SkillUseCase>((ref) {
  final repo = ref.watch(skillRepoProvider);
  return SkillUseCase(repo);
});
