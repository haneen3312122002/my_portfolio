import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/app/layouts/responsive_layout.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/firebase_options.dart';
import 'package:my_portfolio/storyboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: AppResponsiveShell(web: StoryboardPage()),
    );
  }
}
