import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/core/shared/constants/links.dart';
import 'package:my_portfolio/core/shared/utils/helpers.dart';
import 'package:my_portfolio/core/shared/widgets/animations/written_text.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/gradiant_button.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/outline_button.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/grediant_text.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';

class ProfileTextContent extends ConsumerWidget {
  const ProfileTextContent({
    super.key,
    required this.profile,
    required this.centered,
  });

  final ProfileEntity profile;
  final bool centered;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = ref.watch(isEditProvider);

    if (isEdit) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: centered ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: centered
                ? Theme.of(context).textTheme.headlineLarge
                : Theme.of(context).textTheme.displayLarge,
            children: [
              const TextSpan(text: "Hi, I'm Haneen.\n"),
              const TextSpan(text: "I build "),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GradientText(
                  "beautiful",
                  style: centered
                      ? Theme.of(context).textTheme.headlineLarge
                      : Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const TextSpan(text: " mobile experiences\nwith Flutter"),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppBodyText(
          "Experienced Flutter Developer passionate about creating "
          "intuitive & visually appealing applications.",
          textAlign: centered ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 22),
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          spacing: 12,
          runSpacing: 12,
          children: [
            GradientButton(
              onPressed: () => openLinkSmart(MyLinks.email),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.envelope,
                    size: 16,
                    color: AppColors.background,
                  ),
                  SizedBox(width: 8),
                  AppBodyText(
                    'Contact Me',
                    wstyle: TextStyle(color: AppColors.background),
                  ),
                ],
              ),
            ),
            AppOutlineButton(
              onPressed: () => openLinkSmart(MyLinks.github),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.github,
                    size: 16,
                    color: AppColors.primaryPurple,
                  ),
                  SizedBox(width: 8),
                  AppBodyText(
                    'GitHub',
                    wstyle: TextStyle(color: AppColors.primaryPurple),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
