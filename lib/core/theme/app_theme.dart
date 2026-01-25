import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/text_styles.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    final colorScheme = base.colorScheme.copyWith(
      primary: AppColors.heading,
      secondary: AppColors.body,
      surface: AppColors.card,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.scaffold,

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffold,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.body),
        titleTextStyle: TextStyle(
          color: AppColors.heading,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Text theme
      textTheme: TextTheme(
        titleLarge: AppTextStyles.heroTitle,
        titleMedium: AppTextStyles.title,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.body,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.heading,
          foregroundColor: AppColors.body,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.body,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.body,
          side: const BorderSide(color: AppColors.heading, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),

      // IconButton
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColors.body),
        ),
      ),

      // ✅ Buttons used inside dialogs (TextButton / FilledButton)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.body,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.heading,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      // ✅ Dialogs Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.divider, width: 1),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.heading,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.body,
          fontSize: 14.5,
          height: 1.35,
        ),
      ),

      // Inputs / TextField
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        hintStyle: const TextStyle(color: AppColors.disabled),
        labelStyle: const TextStyle(color: AppColors.body),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.body, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
