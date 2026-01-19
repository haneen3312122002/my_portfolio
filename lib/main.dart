import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/storyboard_page.dart';

void main() {
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.light(), home: StoryboardPage());
  }
}
