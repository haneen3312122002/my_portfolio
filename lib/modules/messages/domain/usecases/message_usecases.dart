import 'package:my_portfolio/modules/messages/domain/entities/message_entity.dart';
import 'package:my_portfolio/modules/messages/domain/repositories/message_repositories.dart';

class MessagesUseCase {
  final MessagesRepo _repo;
  MessagesUseCase(this._repo);

  Future<String> addMessage({required MessageEntity message}) {
    return _repo.addMessage(message: message);
  }

  Future<List<MessageEntity>> getAllMessages() => _repo.getAllMessages();

  Future<void> deleteMessage(String id) => _repo.deleteMessage(id);

  Future<MessageEntity?> getMessageById(String id) => _repo.getMessageById(id);
}
