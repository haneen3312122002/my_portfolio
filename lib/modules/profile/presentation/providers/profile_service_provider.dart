import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/infrastructure/firebase/firebase_providers.dart';
import 'package:my_portfolio/modules/profile/data/datasources/profile_datasources.dart';
import 'package:my_portfolio/modules/profile/data/repositories/profile_repositories.dart';
import 'package:my_portfolio/modules/profile/domain/repositories/profile_repositories.dart';
import 'package:my_portfolio/modules/profile/domain/usecases/profile_usecases.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final storage = ref.watch(firebaseStorageProvider);
  return ProfileService(firestore, storage);
});

final profileRepoProvider = Provider<ProfileRepo>((ref) {
  final service = ref.watch(profileServiceProvider);
  return ProfileRepoImpl(service);
});

final profileUseCaseProvider = Provider<ProfileUseCase>((ref) {
  final repo = ref.watch(profileRepoProvider);
  return ProfileUseCase(repo);
});
