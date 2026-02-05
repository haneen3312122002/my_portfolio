import 'package:flutter/material.dart';
import 'package:my_portfolio/core/app/layouts/layouts_enum.dart';
import 'package:my_portfolio/core/app/layouts/responsive_layout.dart';

class AppResponsiveGrid extends StatelessWidget {
  const AppResponsiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.mobile = 1,
    this.tablet = 2,
    this.desktop = 3,
    this.gap = 16,
    this.runGap = 16,
    this.childAspectRatio = 3.2,
    this.padding,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  final int mobile;
  final int tablet;
  final int desktop;

  final double gap;
  final double runGap;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AppResponsiveShell(
      builder: (context, screen) {
        final cols = switch (screen) {
          AppScreenType.mobile => mobile,
          AppScreenType.tablet => tablet,
          AppScreenType.desktop => desktop,
        };

        final grid = GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: gap,
            mainAxisSpacing: runGap,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: itemBuilder,
        );

        if (padding == null) return grid;

        return Padding(padding: padding!, child: grid);
      },
    );
  }
}
