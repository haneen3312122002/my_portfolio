import 'package:flutter/material.dart';
import 'package:my_portfolio/core/shared/widgets/lists/card.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.subtitle,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;

  @override
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
