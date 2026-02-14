import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';
import 'package:my_portfolio/modules/messages/domain/entities/message_entity.dart';
import 'package:my_portfolio/modules/messages/presentation/viewmodels/messages_form_viewmodel.dart';

class ServicesSection extends ConsumerWidget {
  const ServicesSection({super.key, this.title = 'My Services'});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formVm = ref.read(messageFormProvider.notifier);

    // ✅ فقط خدمتين: Portfolio + Video
    final services = <_ServiceCardData>[
      const _ServiceCardData(
        type: ServiceType.portfolio,
        icon: Icons.language_rounded,
        title: 'Portfolio Website',
        description: 'Modern portfolio to help you get hired or freelance.',
      ),
      const _ServiceCardData(
        type: ServiceType.video,
        icon: Icons.play_circle_outline_rounded,
        title: 'App Demo Video',
        description: 'Showcase video to present your app professionally.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final isMobile = w < 650;

        // ✅ بالويب خلي السكشن أوسع عشان الكروت “تغطي المساحة”
        final maxW = isMobile ? double.infinity : 980.0;

        return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSubtitle(title, textAlign: TextAlign.left),
                const SizedBox(height: 14),

                // ✅ Mobile: تحت بعض
                if (isMobile)
                  Column(
                    children: [
                      for (final s in services) ...[
                        _ServiceCard(
                          data: s,
                          onTap: () {
                            formVm.setType(MessageType.service);
                            formVm.setServiceType(s.type);
                            _toastSelected(context, s.title);
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  )
                else
                  // ✅ Web/Desktop: جنب بعض + كبار + يغطوا المساحة
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < services.length; i++) ...[
                        Expanded(
                          child: SizedBox(
                            height: 170, // ✅ كبر الكارد (عدّلي 160/180/200)
                            child: _ServiceCard(
                              data: services[i],
                              onTap: () {
                                formVm.setType(MessageType.service);
                                formVm.setServiceType(services[i].type);
                                _toastSelected(context, services[i].title);
                              },
                            ),
                          ),
                        ),
                        if (i != services.length - 1) const SizedBox(width: 16),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toastSelected(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppBodyText('Selected: $title ✅'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }
}

class _ServiceCardData {
  final ServiceType type;
  final IconData icon;
  final String title;
  final String description;

  const _ServiceCardData({
    required this.type,
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _ServiceCard extends StatefulWidget {
  const _ServiceCard({required this.data, required this.onTap});

  final _ServiceCardData data;
  final VoidCallback onTap;

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.card.withOpacity(0.55);
    final border = AppColors.divider;
    final glow = AppColors.heading;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
              boxShadow: [
                BoxShadow(
                  color: glow.withOpacity(_hover ? 0.22 : 0.12),
                  blurRadius: _hover ? 24 : 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon bubble
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card.withOpacity(0.65),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Icon(
                    widget.data.icon,
                    color: AppColors.body,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBodyText(
                        widget.data.title,
                        wstyle: const TextStyle(fontWeight: FontWeight.w900),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 6),
                      AppBodyText(
                        widget.data.description,
                        maxLines: 3, // ✅ يخليها أنسب لكارد كبير
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.touch_app_rounded, size: 16),
                          SizedBox(width: 6),
                          AppBodyText(
                            'Tap to request',
                            wstyle: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
