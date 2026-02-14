enum MessageType { normal, service }

enum ServiceType { app, portfolio, video }

class MessageEntity {
  final String id;
  final String name;
  final String phone;
  final String email;

  final MessageType type;
  final ServiceType? serviceType;

  final String message;

  const MessageEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.type,
    required this.serviceType,
    required this.message,
  });

  MessageEntity copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    MessageType? type,
    ServiceType? serviceType,
    bool serviceTypeToNull = false,
    String? message,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      type: type ?? this.type,
      serviceType: serviceTypeToNull ? null : (serviceType ?? this.serviceType),
      message: message ?? this.message,
    );
  }
}
