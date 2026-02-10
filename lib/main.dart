import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/app/layouts/layouts_enum.dart';
import 'package:my_portfolio/core/app/layouts/responsive_layout.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/firebase_options.dart';
import 'package:my_portfolio/modules/profile/presentation/screens/home_screen_view.dart';
import 'package:my_portfolio/modules/project/presentation/screens/projects_screen.dart';
import 'package:my_portfolio/project_service_test.dart';
import 'package:my_portfolio/skills_test.dart';

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
      home: AppResponsiveShell(
        builder: (context, screen) {
          switch (screen) {
            case AppScreenType.desktop:
              return const HomePage(); // أو DesktopHomePage( // أو DesktopHomePage()
            case AppScreenType.tablet:
              return const HomePage(); // أو TabletHomePage()
            case AppScreenType.mobile:
              return const HomePage(); // أو MobileHomePage()
          }
        },
      ),
    );
  }
}
