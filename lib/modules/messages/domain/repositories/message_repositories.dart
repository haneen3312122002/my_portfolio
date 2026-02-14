import 'package:my_portfolio/modules/messages/domain/entities/message_entity.dart';

abstract class MessagesRepo {
  Future<String> addMessage({required MessageEntity message});
  Future<List<MessageEntity>> getAllMessages();
  Future<void> deleteMessage(String id);
  Future<MessageEntity?> getMessageById(String id);
}
