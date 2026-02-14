import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/infrastructure/firebase/firebase_providers.dart';
import 'package:my_portfolio/modules/messages/data/datasources/message_datasources.dart';
import 'package:my_portfolio/modules/messages/data/repositories/message_repositories_impl.dart';
import 'package:my_portfolio/modules/messages/domain/repositories/message_repositories.dart';
import 'package:my_portfolio/modules/messages/domain/usecases/message_usecases.dart';

final messagesServiceProvider = Provider<MessagesService>((ref) {
  return MessagesService(ref.read(firebaseFirestoreProvider));
});

final messagesRepoProvider = Provider<MessagesRepo>((ref) {
  return MessagesRepoImpl(ref.read(messagesServiceProvider));
});

final messagesUseCaseProvider = Provider<MessagesUseCase>((ref) {
  return MessagesUseCase(ref.read(messagesRepoProvider));
});
