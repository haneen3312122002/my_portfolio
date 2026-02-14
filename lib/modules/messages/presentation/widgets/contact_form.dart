import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/gradiant_button.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';
import 'package:my_portfolio/modules/messages/domain/entities/message_entity.dart';
import 'package:my_portfolio/modules/messages/presentation/viewmodels/messages_form_viewmodel.dart';
import 'package:my_portfolio/modules/messages/presentation/viewmodels/messages_viewmodel.dart';
import 'package:my_portfolio/modules/messages/presentation/widgets/contact_message.dart';

class ContactMessageForm extends ConsumerStatefulWidget {
  const ContactMessageForm({super.key});

  @override
  ConsumerState<ContactMessageForm> createState() => _ContactMessageFormState();
}

class _ContactMessageFormState extends ConsumerState<ContactMessageForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
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

  Future<void> _submit(bool isLoading) async {
    if (isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final formVm = ref.read(messageFormProvider.notifier);

    final id = await formVm.submit(
      name: _nameCtrl.text,
      phone: _phoneCtrl.text,
      email: _emailCtrl.text,
      messageText: _msgCtrl.text,
    );

    if (!mounted) return;

    if (id != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      _nameCtrl.clear();
      _phoneCtrl.clear();
      _emailCtrl.clear();
      _msgCtrl.clear();
      ref.invalidate(messageFormProvider);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: AppBodyText('Message sent ✅')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: AppBodyText('Failed to send ❌')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(messageFormProvider);
    final formVm = ref.read(messageFormProvider.notifier);

    final async = ref.watch(messagesProvider);
    final isLoading = async.isLoading;

    return LayoutBuilder(
      builder: (context, c) {
        final isMobile = c.maxWidth < 650;

        const gap = 12.0;

        // ====== form widget (نفس الفورم اللي عندك) ======
        final formWidget = Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 920,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSubtitle('Lets Contact', textAlign: TextAlign.left),
                  const SizedBox(height: 24),

                  _row2(
                    isMobile: isMobile,
                    gap: gap,
                    left: TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (v) => _required(v, 'Name is required'),
                    ),
                    right: TextFormField(
                      controller: _phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: (v) => _required(v, 'Phone is required'),
                    ),
                  ),

                  _row2(
                    isMobile: isMobile,
                    gap: gap,
                    left: TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: _emailValidator,
                    ),
                    right: DropdownButtonFormField<MessageType>(
                      dropdownColor: AppColors.card,
                      value: form.type,
                      decoration: const InputDecoration(
                        labelText: 'Message type',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: MessageType.normal,
                          child: AppBodyText('Normal message'),
                        ),
                        DropdownMenuItem(
                          value: MessageType.service,
                          child: AppBodyText('Service request'),
                        ),
                      ],
                      onChanged: isLoading ? null : (v) => formVm.setType(v!),
                    ),
                  ),

                  if (form.type == MessageType.service) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: gap),
                      child: DropdownButtonFormField<ServiceType>(
                        dropdownColor: AppColors.card,
                        value: form.serviceType,
                        decoration: const InputDecoration(labelText: 'Service'),
                        validator: (v) {
                          if (form.type == MessageType.service && v == null) {
                            return 'Choose a service';
                          }
                          return null;
                        },
                        items: const [
                          DropdownMenuItem(
                            value: ServiceType.portfolio,
                            child: AppBodyText('Build a Portfolio'),
                          ),
                          DropdownMenuItem(
                            value: ServiceType.video,
                            child: AppBodyText('Create App Video'),
                          ),
                        ],
                        onChanged: isLoading
                            ? null
                            : (v) => formVm.setServiceType(v),
                      ),
                    ),
                  ],

                  Padding(
                    padding: const EdgeInsets.only(bottom: gap),
                    child: TextFormField(
                      controller: _msgCtrl,
                      minLines: isMobile ? 5 : 6,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        alignLabelWithHint: true,
                      ),
                      validator: (v) => _required(v, 'Message is required'),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      onPressed: isLoading ? null : () => _submit(isLoading),
                      child: const AppBodyText(
                        'Send',
                        wstyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // ====== layout ======
        if (isMobile) return formWidget;

        // ✅ Web/Desktop: رسالة يسار + فورم يمين
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 5,
              child: ContactIntroContent(centered: false),
            ),
            const SizedBox(width: 48),
            Expanded(flex: 6, child: formWidget),
          ],
        );
      },
    );
  }

  // helper for 2 columns fields
  Widget _row2({
    required bool isMobile,
    required double gap,
    required Widget left,
    required Widget right,
  }) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: gap),
            child: left,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: gap),
            child: right,
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: gap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          SizedBox(width: gap),
          Expanded(child: right),
        ],
      ),
    );
  }
}

// ================= LEFT MESSAGE CARD =================

class _Point extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Point({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.body),
          const SizedBox(width: 10),
          Expanded(
            child: AppBodyText(
              text,
              wstyle: const TextStyle(fontWeight: FontWeight.w700),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
