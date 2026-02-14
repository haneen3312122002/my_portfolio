import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/core/shared/constants/links.dart';
import 'package:my_portfolio/core/shared/utils/helpers.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/gradiant_button.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/outline_button.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/grediant_text.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class ContactIntroContent extends StatelessWidget {
  const ContactIntroContent({super.key, this.centered = false});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    final isSmallMobile = (w < 400) || (h < 750);

    final gap1 = isSmallMobile ? 12.0 : 18.0;
    final gap2 = isSmallMobile ? 20.0 : 28.0;

    final baseTitleStyle = centered
        ? Theme.of(context).textTheme.headlineLarge
        : Theme.of(context).textTheme.displayLarge;

    final titleStyle = (baseTitleStyle ?? const TextStyle()).copyWith(
      fontSize: isSmallMobile
          ? (centered ? 42 : 50)
          : ((baseTitleStyle?.fontSize ?? 48) + 6),
      height: 1.12,
      fontWeight: FontWeight.w800,
    );

    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        /// ✅ Title
        RichText(
          textAlign: centered ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: titleStyle,
            children: [
              const TextSpan(text: "Let's "),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GradientText("build", style: titleStyle),
              ),
              const TextSpan(text: " something\n"),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GradientText("amazing", style: titleStyle),
              ),
              const TextSpan(text: " together ✨"),
            ],
          ),
        ),

        SizedBox(height: gap1),

        /// ✅ Description
        AppBodyText(
          "Have an idea or a project in mind?\n"
          "Need a professional Flutter portfolio or a showcase video?\n"
          "Send me a message and let's make it real.",
          textAlign: centered ? TextAlign.center : TextAlign.start,
          wstyle: const TextStyle(
            fontSize: 18,
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: gap2),

        /// ✅ Feature Points
        _PointRow(
          centered: centered,
          icon: Icons.bolt_rounded,
          text: "Fast & clean delivery",
        ),
        const SizedBox(height: 12),
        _PointRow(
          centered: centered,
          icon: Icons.verified_user_rounded,
          text: "Secure & scalable",
        ),
        const SizedBox(height: 12),
        _PointRow(
          centered: centered,
          icon: Icons.auto_awesome_rounded,
          text: "Modern UI / UX",
        ),

        SizedBox(height: gap2),

        // /// ✅ Buttons
        // Wrap(
        //   alignment: centered ? WrapAlignment.center : WrapAlignment.start,
        //   spacing: 14,
        //   runSpacing: 14,
        //   children: [
        //     GradientButton(
        //       onPressed: () => openLinkSmart(MyLinks.email),
        //       child: const Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           FaIcon(
        //             FontAwesomeIcons.paperPlane,
        //             size: 16,
        //             color: AppColors.background,
        //           ),
        //           SizedBox(width: 8),
        //           AppBodyText(
        //             'Send Email',
        //             wstyle: TextStyle(
        //               color: AppColors.background,
        //               fontWeight: FontWeight.w800,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     AppOutlineButton(
        //       onPressed: () => openLinkSmart(MyLinks.linkedin),
        //       child: const Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           FaIcon(
        //             FontAwesomeIcons.linkedin,
        //             size: 16,
        //             color: AppColors.primaryPurple,
        //           ),
        //           SizedBox(width: 8),
        //           AppBodyText(
        //             'LinkedIn',
        //             wstyle: TextStyle(
        //               color: AppColors.primaryPurple,
        //               fontWeight: FontWeight.w700,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class _PointRow extends StatelessWidget {
  const _PointRow({
    required this.centered,
    required this.icon,
    required this.text,
  });

  final bool centered;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: centered
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.body.withOpacity(0.95)),
        const SizedBox(width: 12),
        AppBodyText(
          text,
          wstyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
