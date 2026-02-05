import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/infrastructure/firebase/firebase_providers.dart';
import 'package:my_portfolio/modules/project/data/datasources/projects_datasources.dart';
import 'package:my_portfolio/modules/project/data/repositories/repositories.dart';
import 'package:my_portfolio/modules/project/domain/repositories/project_repositories.dart';
import 'package:my_portfolio/modules/project/domain/usecases/project_usecases.dart';

final projectServeceProvider = Provider<ProjectService>((ref) {
  return ProjectService(
    ref.read(firebaseFirestoreProvider),
    ref.read(firebaseStorageProvider),
  );
});
//................
final repoProvider = Provider<ProjectRepo>((ref) {
  return ProjectRepoImpl(ref.read(projectServeceProvider));
});

///................
final usecaseProvider = Provider<ProjectUseCase>((ref) {
  return ProjectUseCase(ref.read(repoProvider));
});
