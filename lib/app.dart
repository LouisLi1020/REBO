import 'package:flutter/material.dart';
import 'package:rebo/features/red_button/red_button_page.dart';

class ReboApp extends StatelessWidget {
  const ReboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REBO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const RedButtonPage(),
    );
  }
}
