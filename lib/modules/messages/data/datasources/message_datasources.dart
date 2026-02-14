import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio/modules/messages/data/models/message_model.dart';

class MessagesService {
  final FirebaseFirestore _firestore;
  MessagesService(this._firestore);

  static const _collection = 'messages';

  Future<String> addMessage({required MessageModel message}) async {
    try {
      final docRef = _firestore.collection(_collection).doc();
      final id = docRef.id;

      final toSave = MessageModel(
        id: id,
        name: message.name,
        phone: message.phone,
        email: message.email,
        type: message.type,
        serviceType: message.serviceType,
        message: message.message,
      );
      await docRef.set({
        ...toSave.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'new', // optional
      });

      return id;
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<List<MessageModel>> getAllMessages() async {
    try {
      final snap = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs.map(MessageModel.fromDoc).toList();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<void> deleteMessage(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<MessageModel?> getMessageById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      return MessageModel.fromDoc(doc);
    } catch (e, st) {
      return Future.error(e, st);
    }
  }
}
