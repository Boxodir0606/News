import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:news/di/app_di.dart';
import 'package:news/local/shared_preferences.dart';
import 'package:news/pages/landing_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MyPreferences.init();

  setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData.light(useMaterial3: true),
        dark: ThemeData.dark(useMaterial3: true),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "News App",
              theme: theme,
              darkTheme: darkTheme,
              home: SplashPage(),
            )    
        );
  }
}
