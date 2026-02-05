import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AppTypewriterText extends StatelessWidget {
  const AppTypewriterText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.speed = const Duration(milliseconds: 30),
    this.cursor = '|',
    this.repeat = false,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  /// سرعة الكتابة
  final Duration speed;

  /// شكل المؤشر
  final String cursor;

  /// يعيد الأنيميشن؟
  final bool repeat;

  /// نفس خيارات Text (تُطبّق للنص النهائي)
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    final effectiveAlign = textAlign ?? TextAlign.start;

    return DefaultTextStyle(
      style: effectiveStyle,
      textAlign: effectiveAlign,
      child: AnimatedTextKit(
        isRepeatingAnimation: repeat,
        totalRepeatCount: 1,
        animatedTexts: [
          TypewriterAnimatedText(text, speed: speed, cursor: cursor),
        ],
        // UX: لو ضغط المستخدم، يعرض النص كامل
        displayFullTextOnTap: true,
        stopPauseOnTap: true,

        // بعد اكتمال الكتابة، AnimatedTextKit بيعرض النص النهائي.
        // maxLines/overflow/softWrap ممكن تحتاجها للنص النهائي داخل Layout ضيق.
      ),
    );
  }
}
