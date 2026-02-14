import 'package:flutter/material.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class AppCopyright extends StatelessWidget {
  const AppCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(thickness: 0.6, color: AppColors.divider.withOpacity(0.6)),
            const SizedBox(height: 18),
            AppBodyText(
              "© $year Haneen. All rights reserved.",
              textAlign: TextAlign.center,
              wstyle: TextStyle(
                fontSize: 14,
                color: AppColors.body.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            AppBodyText(
              "Built with Flutter 💙",
              textAlign: TextAlign.center,
              wstyle: TextStyle(
                fontSize: 13,
                color: AppColors.body.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
