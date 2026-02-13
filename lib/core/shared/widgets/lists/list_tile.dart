import 'package:flutter/material.dart';
import 'package:my_portfolio/core/shared/widgets/lists/card.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.subtitle,

    // ✅ جديد: تحكم بالمساحة بدون ما نكسر القديم
    this.padding,
    this.compact = false,
    this.gap = 12,
    this.subtitleGap = 6,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;

  /// لو بديتي تحطي padding من برا
  final EdgeInsetsGeometry? padding;

  /// ✅ يقلل المساحات للموبايل/الـGrid
  final bool compact;

  /// مسافة بين leading والمحتوى / وبين المحتوى و trailing
  final double gap;

  /// مسافة بين العنوان والـsubtitle
  final double subtitleGap;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry resolvedPadding =
        padding ??
        (compact
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 10));

    final double resolvedGap = compact ? 10 : gap;
    final double resolvedSubtitleGap = compact ? 4 : subtitleGap;

    return AppCard(
      padding: resolvedPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ أفضل مع subtitle
        children: [
          if (leading != null) ...[leading!, SizedBox(width: resolvedGap)],
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
                if (subtitle != null) ...[
                  SizedBox(height: resolvedSubtitleGap),
                  subtitle!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: resolvedGap), trailing!],
        ],
      ),
    );
  }
}
