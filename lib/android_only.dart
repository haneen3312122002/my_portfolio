import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class AndroidOnly extends StatelessWidget {
  final Widget child;
  final Widget fallback;

  const AndroidOnly({
    super.key,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    final isAndroid = !kIsWeb && Platform.isAndroid;
    return isAndroid ? child : fallback;
  }
}
