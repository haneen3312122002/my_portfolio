import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/modules/messages/domain/entities/message_entity.dart';
import 'package:my_portfolio/modules/messages/presentation/viewmodels/messages_viewmodel.dart';

class MessageFormState {
  final MessageType type;
  final ServiceType? serviceType;

  const MessageFormState({this.type = MessageType.normal, this.serviceType});

  MessageFormState copyWith({
    MessageType? type,
    ServiceType? serviceType,
    bool serviceTypeToNull = false,
  }) {
    return MessageFormState(
      type: type ?? this.type,
      serviceType: serviceTypeToNull ? null : (serviceType ?? this.serviceType),
    );
  }
}

final messageFormProvider =
    NotifierProvider.autoDispose<MessageFormNotifier, MessageFormState>(
      MessageFormNotifier.new,
    );

class MessageFormNotifier extends Notifier<MessageFormState> {
  @override
  MessageFormState build() => const MessageFormState();

  void setType(MessageType t) {
    // لو صارت normal امسح serviceType
    state = state.copyWith(
      type: t,
      serviceTypeToNull: (t == MessageType.normal),
    );
  }

  void setServiceType(ServiceType? s) => state = state.copyWith(serviceType: s);

  Future<String?> submit({
    required String name,
    required String phone,
    required String email,
    required String messageText,
  }) async {
    final vm = ref.read(messagesProvider.notifier);

    final entity = MessageEntity(
      id: '',
      name: name.trim(),
      phone: phone.trim(),
      email: email.trim(),
      type: state.type,
      serviceType: state.type == MessageType.service ? state.serviceType : null,
      message: messageText.trim(),
    );

    return vm.addMessage(message: entity);
  }
}
