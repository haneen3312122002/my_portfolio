import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final BorderRadius borderRadius;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  static const _minSize = Size(160, 46);
  static const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 10);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: _minSize,
          padding: _padding,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,

          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0, // ✅ حتى ما يبين اختلاف عن الـ outline

          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide.none, // ✅ يمنع بوردر الثيم
          ),

          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        child: child,
      ),
    );
  }
}
