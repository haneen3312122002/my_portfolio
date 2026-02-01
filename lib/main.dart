import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/app/layouts/responsive_layout.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/firebase_options.dart';
import 'package:my_portfolio/modules/project/presentation/screens/projects_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
  };

  await runZonedGuarded(
    () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {
      debugPrint('ZONED ERROR => $error');
      debugPrintStack(stackTrace: stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: AppResponsiveShell(web: ProjectsPage()),
    );
  }
}
