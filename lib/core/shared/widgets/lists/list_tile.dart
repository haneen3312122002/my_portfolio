import 'package:flutter/material.dart';
import 'package:my_portfolio/core/shared/widgets/lists/card.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
    this.subtitle,
  });

  final String title;
  final Widget? icon;
  final Widget? subtitle;

  /// أي شي بدك تضيفه لاحقًا (progress, button, badge…)
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 12)],

          // ===== TEXT =====
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle != null) ...[const SizedBox(height: 6), subtitle!],
              ],
            ),
          ),

          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}
