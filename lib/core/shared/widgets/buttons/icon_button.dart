import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  //haver text
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, tooltip: tooltip, icon: Icon(icon));
  }
}
