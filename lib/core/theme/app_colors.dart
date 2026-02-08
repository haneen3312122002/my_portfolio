import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// Main Headings (أوضح + أنظف)
  static const Color heading = Color(0xFFBFE8F4);

  /// Buttons (أفتح + أنعم)
  static const Color button = Color(0xFF9ABBC6);

  /// Body text, icons, borders
  static const Color body = Color(0xFF8DB8C6);

  /// Cards background (أفتح شوي مع شفافية)
  static const Color card = Color.fromARGB(153, 45, 47, 85);

  /// Basics
  static const Color background = Color(0xFFFFFFFF);
  static const Color scaffold = Color(0xFFF4F8FB);

  /// States
  static const Color divider = Color(0x448DB8C6);
  static const Color disabled = Color(0x668DB8C6);
  static const Color primaryPurple = Color.fromARGB(255, 124, 122, 255);

  static const Color primaryBlue = Color.fromARGB(255, 184, 31, 255);

  /// 🔥 Glow / Neon helpers
  static const Color glowSoft = Color(0x80BFE8F4);
  static const Color glowStrong = Color(0xCCBFE8F4);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryBlue],
  );
}
