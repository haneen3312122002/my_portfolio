import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/modules/messages/domain/entities/message_entity.dart';
import 'package:my_portfolio/modules/messages/domain/usecases/message_usecases.dart';
import 'package:my_portfolio/modules/messages/presentation/providers/providers.dart';

final messagesProvider =
    AsyncNotifierProvider<MessagesViewModel, List<MessageEntity>>(
      MessagesViewModel.new,
    );

class MessagesViewModel extends AsyncNotifier<List<MessageEntity>> {
  MessagesUseCase get _useCase => ref.read(messagesUseCaseProvider);

  Future<List<MessageEntity>> _fetchAll() => _useCase.getAllMessages();

  @override
  Future<List<MessageEntity>> build() async {
    return _fetchAll();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAll);
  }

  Future<String?> addMessage({required MessageEntity message}) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      final id = await _useCase.addMessage(message: message);
      final list = await _fetchAll();
      state = AsyncData(list);
      return id;
    });

    if (result.hasError) {
      state = AsyncError(result.error!, result.stackTrace!);
      return null;
    }
    return result.value;
  }

  Future<void> deleteMessage(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _useCase.deleteMessage(id);
      return await _fetchAll();
    });
  }
}
