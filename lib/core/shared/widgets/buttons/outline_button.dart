import 'package:flutter/material.dart';

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    super.key,
    this.child,
    this.title,
    required this.onPressed,
    this.icon,
  });

  final String? title;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? child;

  static const _minSize = Size(160, 46);
  static const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 10);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: _minSize,
        padding: _padding,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        // لو حسيتي لسه أكبر بصريًا بسبب البوردر، خلي البوردر أنحف:
        //   side: const BorderSide(width: 1),
      ),
      child: child ?? Text(title ?? ''),
    );
  }
}
