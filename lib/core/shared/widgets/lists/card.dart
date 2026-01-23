import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    this.title,
    required this.child,
    this.onNext,
    this.padding = const EdgeInsets.all(20),
    this.gap = 12,
    this.elevation = 2,
    this.borderRadius = 16,
  });

  final Widget? title;
  final Widget child;
  final VoidCallback? onNext;

  final EdgeInsetsGeometry padding;
  final double gap;
  final double elevation;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[title!, SizedBox(height: gap)],
        Row(
          crossAxisAlignment: CrossAxisAlignment.center, // ✅ المهم
          children: [
            Expanded(
              child: Card(
                elevation: elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Padding(padding: padding, child: child),
              ),
            ),
            if (onNext != null) ...[
              const SizedBox(width: 12),
              IconButton(
                onPressed: onNext,
                icon: const Icon(Icons.navigate_next_outlined, size: 70),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
