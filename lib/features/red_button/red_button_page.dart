import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rebo/features/red_button/widgets/red_button.dart';
import 'package:rebo/generated/app_localizations.dart';
import 'package:rebo/shared/services/storage_service.dart';
import 'package:rebo/shared/widgets/settings_sheet.dart';

class RedButtonPage extends StatefulWidget {
  const RedButtonPage({
    super.key,
    this.onThemeChanged,
    this.onLocaleChanged,
  });

  final VoidCallback? onThemeChanged;
  final VoidCallback? onLocaleChanged;

  @override
  State<RedButtonPage> createState() => _RedButtonPageState();
}

class _RedButtonPageState extends State<RedButtonPage> {
  int _clickCount = 0;
  int _highScore = 0;
  Color _buttonColor = Colors.red;
  String _soundAssetPath = 'audio/click.mp3';

  @override
  void initState() {
    super.initState();
    _loadScores();
    _loadButtonColor();
    _loadSoundPreset();
  }

  Future<void> _loadButtonColor() async {
    final id = await StorageService.getButtonColor();
    if (!mounted) return;
    setState(() => _buttonColor = _colorFromId(id));
  }

  static Color _colorFromId(String id) {
    switch (id) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Future<void> _loadSoundPreset() async {
    final id = await StorageService.getSoundPreset();
    if (!mounted) return;
    setState(() {
      _soundAssetPath = id == 'classic' ? 'audio/click.mp3' : 'audio/click.mp3';
    });
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

  static AppLocalizations _l(BuildContext context) =>
      AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    final l = _l(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(l.redButton),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await SettingsSheet.show(
                context,
                onThemeChanged: widget.onThemeChanged,
                onLocaleChanged: widget.onLocaleChanged,
                onCustomizationChanged: () async {
                  await _loadButtonColor();
                  await _loadSoundPreset();
                  if (mounted) setState(() {});
                },
              );
            },
            tooltip: _l(context).settings,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetScores,
            tooltip: l.resetScores,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${l.clicks}: $_clickCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${l.highScore}: $_highScore',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            RedButton(
              onPressed: _handleButtonPress,
              buttonColor: _buttonColor,
              soundAssetPath: _soundAssetPath,
            ),
          ],
        ),
      ),
    );
  }
}
