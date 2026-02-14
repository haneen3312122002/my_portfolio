import 'package:my_portfolio/modules/messages/data/datasources/message_datasources.dart';
import 'package:my_portfolio/modules/messages/data/models/message_model.dart';
import 'package:my_portfolio/modules/messages/domain/entities/message_entity.dart';
import 'package:my_portfolio/modules/messages/domain/repositories/message_repositories.dart';

class MessagesRepoImpl implements MessagesRepo {
  final MessagesService _service;
  MessagesRepoImpl(this._service);

  @override
  Future<String> addMessage({required MessageEntity message}) {
    return _service.addMessage(message: MessageModel.fromEntity(message));
  }

  @override
  Future<List<MessageEntity>> getAllMessages() async {
    final models = await _service.getAllMessages();
    return models; // MessageModel extends MessageEntity
  }

  @override
  Future<void> deleteMessage(String id) => _service.deleteMessage(id);

  @override
  Future<MessageEntity?> getMessageById(String id) =>
      _service.getMessageById(id);
}
