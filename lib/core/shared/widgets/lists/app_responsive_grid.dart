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
    this.useShell = true,
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

  /// ✅ true: استخدم AppResponsiveShell (السلوك القديم) — ما بكسر الأماكن الثانية
  /// ✅ false: استخدم LayoutBuilder (أفضل داخل Sections/Scroll)
  final bool useShell;

  @override
  Widget build(BuildContext context) {
    // ✅ المسار الجديد (للـSections داخل Scroll)
    if (!useShell) {
      return LayoutBuilder(
        builder: (context, constraints) {
          // بعض الـparents بيعطوا maxWidth غير bounded، فبنرجع لـ MediaQuery
          final mediaW = MediaQuery.of(context).size.width;
          final w = (constraints.hasBoundedWidth && constraints.maxWidth > 0)
              ? constraints.maxWidth
              : mediaW;

          int cols;
          if (w < 650) {
            cols = mobile;
          } else if (w < 1100) {
            cols = tablet;
          } else {
            cols = desktop;
          }

          cols = cols < 1 ? 1 : cols;

          final grid = GridView.builder(
            primary: false,
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

    // ✅ المسار القديم (كما هو) — للأماكن اللي معتمدة على Shell
    return AppResponsiveShell(
      builder: (context, screen) {
        final cols = switch (screen) {
          AppScreenType.mobile => mobile,
          AppScreenType.tablet => tablet,
          AppScreenType.desktop => desktop,
        };

        final grid = GridView.builder(
          primary: false,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols < 1 ? 1 : cols, // حماية
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
