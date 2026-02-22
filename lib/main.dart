import 'package:flutter/material.dart';
import 'package:rebo/app.dart';
import 'package:rebo/shared/services/storage_service.dart';

void main() {
  runApp(const AppWrapper());
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadLocale();
  }

  Future<void> _loadTheme() async {
    final stored = await StorageService.getThemeMode();
    if (!mounted) return;
    setState(() {
      _themeMode = stored == 'dark'
          ? ThemeMode.dark
          : stored == 'light'
              ? ThemeMode.light
              : ThemeMode.system;
    });
  }

  Future<void> _loadLocale() async {
    final code = await StorageService.getLocale();
    if (!mounted) return;
    setState(() {
      if (code.isEmpty) {
        _locale = null;
      } else {
        final parts = code.split('_');
        _locale = parts.length >= 2
            ? Locale(parts[0], parts[1])
            : Locale(parts[0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReboApp(
      themeMode: _themeMode,
      locale: _locale,
      onThemeChanged: _loadTheme,
      onLocaleChanged: _loadLocale,
    );
  }
}
