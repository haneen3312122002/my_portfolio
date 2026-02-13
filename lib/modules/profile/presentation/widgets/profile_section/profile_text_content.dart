import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/core/shared/constants/links.dart';
import 'package:my_portfolio/core/shared/utils/helpers.dart';
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

    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    // ✅ فقط للموبايل/الشاشات القصيرة
    final isSmallMobile = (w < 400) || (h < 750);

    // ✅ مسافات أقل للموبايل
    final gap1 = isSmallMobile ? 10.0 : 14.0;
    final gap2 = isSmallMobile ? 16.0 : 22.0;

    // ✅ عنوان أصغر للموبايل (بدون ما نلمس الديسكتوب)
    final baseTitleStyle = centered
        ? Theme.of(context).textTheme.headlineLarge
        : Theme.of(context).textTheme.displayLarge;

    final titleStyle = (baseTitleStyle ?? const TextStyle()).copyWith(
      fontSize: isSmallMobile
          ? (centered ? 38 : 46) // موبايل
          : (baseTitleStyle?.fontSize), // ديسكتوب زي ما هو
      height: isSmallMobile ? 1.08 : 1.1,
    );

    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // ✅ Title Responsive
        RichText(
          textAlign: centered ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: titleStyle,
            children: [
              const TextSpan(text: "Hi, I'm Haneen.\n"),
              const TextSpan(text: "I build "),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GradientText("beautiful", style: titleStyle),
              ),
              const TextSpan(text: " mobile experiences\nwith Flutter"),
            ],
          ),
        ),

        SizedBox(height: gap1),

        AppBodyText(
          "Experienced Flutter Developer passionate about creating "
          "intuitive & visually appealing applications.",
          textAlign: centered ? TextAlign.center : TextAlign.start,
        ),

        SizedBox(height: gap2),

        // ✅ الأزرار عندك Wrap ممتاز للموبايل، خلّيه كما هو
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
