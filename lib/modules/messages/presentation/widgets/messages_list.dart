import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/modules/messages/presentation/viewmodels/messages_viewmodel.dart';
import 'package:my_portfolio/modules/messages/domain/entities/message_entity.dart';

class MessagesAdminList extends ConsumerWidget {
  const MessagesAdminList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(messagesProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('No messages'));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) => _MessageTile(message: list[i]),
        );
      },
    );
  }
}

class _MessageTile extends ConsumerWidget {
  final MessageEntity message;
  const _MessageTile({required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBusy = ref.watch(messagesProvider).isLoading;

    return Card(
      child: ListTile(
        title: Text(message.name),
        subtitle: Text(
          message.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: isBusy
              ? null
              : () => ref
                    .read(messagesProvider.notifier)
                    .deleteMessage(message.id),
        ),
      ),
    );
  }
}
