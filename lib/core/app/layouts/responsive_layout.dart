import 'package:flutter/material.dart';
import 'package:my_portfolio/core/app/layouts/layouts_enum.dart';

class AppResponsiveShell extends StatelessWidget {
  const AppResponsiveShell({super.key, required this.builder});

  final Widget Function(BuildContext context, AppScreenType screenType) builder;

  static const double mobileMax = 600;
  static const double tabletMax = 1000;

  static AppScreenType getType(double width) {
    if (width < mobileMax) return AppScreenType.mobile;
    if (width < tabletMax) return AppScreenType.tablet;
    return AppScreenType.desktop;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final type = getType(constraints.maxWidth);
        return builder(context, type);
      },
    );
  }
}
