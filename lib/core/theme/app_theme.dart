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
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.card),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),

          // نفس rounded تبع الـ dialogs/inputs
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.divider, width: 1),
            ),
          ),

          // padding للـ popup نفسه
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 6),
          ),
        ),
      ),

      // ✅ DropdownMenu (Material 3) theme (optional but nice if you use DropdownMenu widget)
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextStyles.body.copyWith(fontSize: 14.5),
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
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.card),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.divider, width: 1),
            ),
          ),
        ),
      ),

      // ✅ Item style inside dropdown popup
      listTileTheme: ListTileThemeData(
        dense: true,
        iconColor: AppColors.body,
        textColor: AppColors.body,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      // ✅ Better default icon colors for dropdown arrow etc.
      iconTheme: const IconThemeData(color: AppColors.body),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.scaffold,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.body),
        titleTextStyle: AppTextStyles.title.copyWith(fontSize: 18),
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
        headlineLarge: AppTextStyles.heroTitle,
        headlineMedium: AppTextStyles.heroTitle.copyWith(fontSize: 36),
        headlineSmall: AppTextStyles.title.copyWith(fontSize: 26),

        titleLarge: AppTextStyles.title.copyWith(fontSize: 22),
        titleMedium: AppTextStyles.subtitle.copyWith(fontSize: 18),
        titleSmall: AppTextStyles.title.copyWith(fontSize: 16),
        displayLarge: AppTextStyles.displayLarge,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.body.copyWith(fontSize: 14),
      ),

      // ElevatedButton
      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.body,
          foregroundColor: AppColors.heading,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.body,

          // ✅ نفس الحجم بالضبط
          minimumSize: const Size(160, 46),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,

          // ✅ بوردر خفيف جدًا عشان يقرب من الـ outlined
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: AppColors.primaryPurple.withOpacity(0.22),
              width: 0.8,
            ),
          ),

          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          elevation: 0, // خليها 0 إذا بدك نفس إحساس الـ outline
          shadowColor: Colors.transparent,
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.body,

          // ✅ نفس الحجم بالضبط
          minimumSize: const Size(160, 46),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,

          // ✅ بوردر خفيف عشان يطابق الـ Elevated (مش سميك)
          side: BorderSide(color: AppColors.primaryPurple, width: 0.8),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
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
        titleTextStyle: AppTextStyles.title.copyWith(fontSize: 18),
        contentTextStyle: AppTextStyles.body.copyWith(
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
