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

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ElevatedButton.styleFrom(maximumSize: Size(200, 40)),

      onPressed: onPressed,
      child: child,
    );
  }
}
