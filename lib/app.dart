import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rebo/features/red_button/red_button_page.dart';
import 'package:rebo/generated/app_localizations.dart';

class ReboApp extends StatelessWidget {
  const ReboApp({
    super.key,
    required this.themeMode,
    this.locale,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  final ThemeMode themeMode;
  final Locale? locale;
  final VoidCallback onThemeChanged;
  final VoidCallback onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REBO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: RedButtonPage(
        onThemeChanged: onThemeChanged,
        onLocaleChanged: onLocaleChanged,
      ),
    );
  }
}
