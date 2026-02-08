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

    // ✅ Neon options
    this.neonBottomGlow = true,
    this.neonPurple = const Color.fromARGB(255, 124, 122, 255),
    this.neonBlue = const Color.fromARGB(255, 184, 31, 255),
  });

  final Widget? title;
  final Widget child;
  final VoidCallback? onNext;

  final EdgeInsetsGeometry padding;
  final double gap;
  final double elevation;
  final double borderRadius;

  // ✅ Neon
  final bool neonBottomGlow;
  final Color neonPurple;
  final Color neonBlue;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(padding: padding, child: child),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[title!, SizedBox(height: gap)],
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: neonBottomGlow
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        boxShadow: [
                          // 🟣 خفيف جدًا
                          BoxShadow(
                            color: neonPurple.withValues(alpha: 0.30),
                            blurRadius: 22,
                            spreadRadius: -6,
                            offset: Offset.zero, // تحت فقط
                          ),
                          // 🔵 خفيف جدًا
                          BoxShadow(
                            color: neonBlue.withValues(alpha: 0.20),
                            blurRadius: 28,
                            spreadRadius: -8,
                            offset: Offset.zero, // تحت فقط
                          ),
                        ],
                      ),
                      child: card,
                    )
                  : card,
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
