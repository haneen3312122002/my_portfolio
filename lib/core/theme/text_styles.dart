import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  /// 🔥 Hero Title (الواجهة الرئيسية)
  static final TextStyle heroTitle = GoogleFonts.spaceGrotesk(
    fontSize: 44,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.heading,
    shadows: const [
      Shadow(offset: Offset(0, 0), blurRadius: 12, color: Color(0x66B7DEEB)),
      Shadow(offset: Offset(0, 0), blurRadius: 28, color: Color(0x33B7DEEB)),
    ],
  );

  /// 🟣 Display Large
  static final TextStyle displayLarge = GoogleFonts.spaceGrotesk(
    fontSize: 80,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    color: AppColors.heading,
  );

  /// 🟣 Display Small
  static final TextStyle displaySmall = GoogleFonts.spaceGrotesk(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
    color: AppColors.heading,
  );

  /// 🟡 Section titles
  static final TextStyle title = GoogleFonts.spaceGrotesk(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.heading,
  );

  /// 📝 Subtitles
  static final TextStyle subtitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.body,
  );

  /// ✍️ Body text
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.primaryPurple,
  );
}
