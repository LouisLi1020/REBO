import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rebo/features/red_button/widgets/red_button.dart';
import 'package:rebo/shared/services/storage_service.dart';

class RedButtonPage extends StatefulWidget {
  const RedButtonPage({super.key});

  @override
  State<RedButtonPage> createState() => _RedButtonPageState();
}

class _RedButtonPageState extends State<RedButtonPage> {
  int _clickCount = 0;
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final clickCount = await StorageService.getClickCount();
    final highScore = await StorageService.getHighScore();
    if (mounted) {
      setState(() {
        _clickCount = clickCount;
        _highScore = highScore;
      });
    }
  }

  void _handleButtonPress() {
    setState(() {
      _clickCount++;
      if (_clickCount > _highScore) _highScore = _clickCount;
    });
    StorageService.incrementClickCount();
    HapticFeedback.mediumImpact();
  }

  void _resetScores() {
    setState(() => _clickCount = 0);
    StorageService.resetScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Red Button'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetScores,
            tooltip: 'Reset Scores',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Clicks: $_clickCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'High Score: $_highScore',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            RedButton(onPressed: _handleButtonPress),
          ],
        ),
      ),
    );
  }
}
