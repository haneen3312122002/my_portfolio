import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio/modules/messages/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.email,
    required super.type,
    required super.serviceType,
    required super.message,
  });

  static MessageType _typeFromString(String? v) {
    switch ((v ?? '').toLowerCase()) {
      case 'service':
        return MessageType.service;
      case 'normal':
      default:
        return MessageType.normal;
    }
  }

  static ServiceType? _serviceFromString(String? v) {
    switch ((v ?? '').toLowerCase()) {
      case 'app':
        return ServiceType.app;
      case 'portfolio':
        return ServiceType.portfolio;
      case 'video':
        return ServiceType.video;
      default:
        return null;
    }
  }

  static String _typeToString(MessageType t) =>
      (t == MessageType.service) ? 'service' : 'normal';

  static String? _serviceToString(ServiceType? s) {
    if (s == null) return null;
    switch (s) {
      case ServiceType.app:
        return 'app';
      case ServiceType.portfolio:
        return 'portfolio';
      case ServiceType.video:
        return 'video';
    }
  }

  factory MessageModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data() ?? {};
    return MessageModel(
      id: doc.id,
      name: (json['name'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      type: _typeFromString(json['type'] as String?),
      serviceType: _serviceFromString(json['serviceType'] as String?),
      message: (json['message'] as String?) ?? '',
    );
  }

  factory MessageModel.fromEntity(MessageEntity e) => MessageModel(
    id: e.id,
    name: e.name,
    phone: e.phone,
    email: e.email,
    type: e.type,
    serviceType: e.serviceType,
    message: e.message,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'type': _typeToString(type),
    'serviceType': _serviceToString(serviceType),
    'message': message,
  };
}
