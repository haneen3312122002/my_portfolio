import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_portfolio/modules/messages/domain/entities/message_entity.dart';
import 'package:my_portfolio/modules/messages/presentation/viewmodels/messages_form_viewmodel.dart';
import 'package:my_portfolio/modules/messages/presentation/viewmodels/messages_viewmodel.dart';

class MessagesDebugPanel extends ConsumerStatefulWidget {
  const MessagesDebugPanel({super.key});

  @override
  ConsumerState<MessagesDebugPanel> createState() => _MessagesDebugPanelState();
}

class _MessagesDebugPanelState extends ConsumerState<MessagesDebugPanel> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _msgCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _msgCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameCtrl.clear();
    _phoneCtrl.clear();
    _emailCtrl.clear();
    _msgCtrl.clear();
    ref.invalidate(messageFormProvider);
  }

  String? _required(String? v, String msg) =>
      (v ?? '').trim().isEmpty ? msg : null;

  String? _emailValidator(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Email is required';
    final ok = RegExp(r'^\S+@\S+\.\S+$').hasMatch(t);
    if (!ok) return 'Invalid email';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(messagesProvider);
    final isLoading = async.isLoading;

    final formState = ref.watch(messageFormProvider);
    final formVm = ref.read(messageFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Messages Debug (Firestore)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            async.when(
              data: (list) => Text('Count: ${list.length}'),
              loading: () => const Text('Loading...'),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 12),

            // ===== FORM =====
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (v) => _required(v, 'Name is required'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _phoneCtrl,
                        decoration: const InputDecoration(labelText: 'Phone'),
                        validator: (v) => _required(v, 'Phone is required'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 12),

                      // Type dropdown
                      DropdownButtonFormField<MessageType>(
                        value: formState.type,
                        decoration: const InputDecoration(
                          labelText: 'Message type',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: MessageType.normal,
                            child: Text('Normal message'),
                          ),
                          DropdownMenuItem(
                            value: MessageType.service,
                            child: Text('Service request'),
                          ),
                        ],
                        onChanged: isLoading ? null : (v) => formVm.setType(v!),
                      ),

                      // Service dropdown (conditional)
                      if (formState.type == MessageType.service) ...[
                        const SizedBox(height: 10),
                        DropdownButtonFormField<ServiceType>(
                          value: formState.serviceType,
                          decoration: const InputDecoration(
                            labelText: 'Service type',
                          ),
                          validator: (v) {
                            if (formState.type == MessageType.service &&
                                v == null) {
                              return 'Choose a service';
                            }
                            return null;
                          },
                          items: const [
                            DropdownMenuItem(
                              value: ServiceType.app,
                              child: Text('Build an App'),
                            ),
                            DropdownMenuItem(
                              value: ServiceType.portfolio,
                              child: Text('Build a Portfolio'),
                            ),
                            DropdownMenuItem(
                              value: ServiceType.video,
                              child: Text('Create App Video'),
                            ),
                          ],
                          onChanged: isLoading
                              ? null
                              : (v) => formVm.setServiceType(v),
                        ),
                      ],

                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _msgCtrl,
                        minLines: 3,
                        maxLines: 7,
                        decoration: const InputDecoration(
                          labelText: 'Message text',
                        ),
                        validator: (v) => _required(v, 'Message is required'),
                      ),
                      const SizedBox(height: 12),

                      // Buttons row
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      debugPrint('TEST: refresh()');
                                      await ref
                                          .read(messagesProvider.notifier)
                                          .refresh();
                                      debugPrint('DONE: refresh()');
                                    },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: isLoading ? null : _clearForm,
                              icon: const Icon(Icons.clear),
                              label: const Text('Clear'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Add message
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.send),
                          label: Text(isLoading ? 'Sending…' : 'Add Message'),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }

                                  debugPrint('TEST: addMessage()');

                                  final id = await formVm.submit(
                                    name: _nameCtrl.text,
                                    phone: _phoneCtrl.text,
                                    email: _emailCtrl.text,
                                    messageText: _msgCtrl.text,
                                  );

                                  debugPrint('DONE: addMessage => id: $id');

                                  if (!mounted) return;

                                  if (id != null) {
                                    _clearForm();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Message added ✅'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Failed ❌')),
                                    );
                                  }
                                },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Delete first
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onError,
                          ),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete First Message'),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final list =
                                      ref.read(messagesProvider).value ?? [];
                                  if (list.isEmpty) {
                                    debugPrint('No messages to delete');
                                    return;
                                  }

                                  final first = list.first;
                                  debugPrint(
                                    'TEST: deleteMessage id: ${first.id}',
                                  );
                                  await ref
                                      .read(messagesProvider.notifier)
                                      .deleteMessage(first.id);
                                  debugPrint('DONE: deleteMessage');
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 10),

            // ===== LIST =====
            Expanded(
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (list) {
                  if (list.isEmpty) {
                    return const Center(child: Text('No messages yet'));
                  }

                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _MessageCard(message: list[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends ConsumerWidget {
  final MessageEntity message;
  const _MessageCard({required this.message});

  String _typeLabel(MessageType t) =>
      (t == MessageType.service) ? 'Service' : 'Normal';

  String _serviceLabel(ServiceType? s) {
    if (s == null) return '-';
    switch (s) {
      case ServiceType.app:
        return 'App';
      case ServiceType.portfolio:
        return 'Portfolio';
      case ServiceType.video:
        return 'Video';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBusy = ref.watch(messagesProvider).isLoading;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    message.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(_typeLabel(message.type)),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: isBusy
                      ? null
                      : () async {
                          await ref
                              .read(messagesProvider.notifier)
                              .deleteMessage(message.id);
                        },
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('Phone: ${message.phone}'),
            Text('Email: ${message.email}'),
            Text('Service: ${_serviceLabel(message.serviceType)}'),
            const SizedBox(height: 10),
            Text(message.message, maxLines: 4, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
