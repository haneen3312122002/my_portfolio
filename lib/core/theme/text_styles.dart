import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  /// 🔥 Titles / Headings (Neon using App Colors only)
  static const TextStyle heroTitle = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
    color: AppColors.heading,
    shadows: [
      Shadow(
        offset: Offset(0, 0),
        blurRadius: 12,
        color: Color(0x99B7DEEB), // 60%
      ),
      Shadow(
        offset: Offset(0, 0),
        blurRadius: 28,
        color: Color(0x33B7DEEB), // 20%
      ),
    ],
  );
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.heading,
  );
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.body,
  );

  /// ✍️ Body text
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.body,
  );
}
