import 'package:flutter/material.dart';

class AppResponsiveShell extends StatelessWidget {
  const AppResponsiveShell({super.key, required this.web, this.mobile});

  final Widget web;
  final Widget? mobile;

  static const double mobileMaxWidth = 600; // breakpoint

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < mobileMaxWidth;

        if (isMobile) {
          return mobile ?? web;
        }
        return web;
      },
    );
  }
}
