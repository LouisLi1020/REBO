import 'package:flutter/material.dart';
import 'package:rebo/generated/app_localizations.dart';
import 'package:rebo/shared/services/storage_service.dart';

/// Settings overlay content. Reference: design/mobile-ui-reference.png (SETTINGS overlay).
/// Sections: Theme (B.2), Audio (B.4), Language (B.5) — added in order.
class SettingsSheet extends StatefulWidget {
  const SettingsSheet({
    super.key,
    this.onThemeChanged,
    this.onLocaleChanged,
    this.onCustomizationChanged,
  });

  final VoidCallback? onThemeChanged;
  final VoidCallback? onLocaleChanged;
  final VoidCallback? onCustomizationChanged;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onThemeChanged,
    VoidCallback? onLocaleChanged,
    VoidCallback? onCustomizationChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SettingsSheet(
        onThemeChanged: onThemeChanged,
        onLocaleChanged: onLocaleChanged,
        onCustomizationChanged: onCustomizationChanged,
      ),
    );
  }

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  String _themeMode = 'system';
  String _buttonColor = 'red';
  String _soundPreset = 'default';
  String _locale = '';
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final stored = await StorageService.getThemeMode();
    final color = await StorageService.getButtonColor();
    final sound = await StorageService.getSoundPreset();
    final loc = await StorageService.getLocale();
    if (!mounted) return;
    setState(() {
      _themeMode = stored;
      _buttonColor = color;
      _soundPreset = sound;
      _locale = loc;
      _loaded = true;
    });
  }

  Future<void> _setTheme(String value) async {
    await StorageService.setThemeMode(value);
    if (!mounted) return;
    setState(() => _themeMode = value);
    widget.onThemeChanged?.call();
  }

  Future<void> _setButtonColor(String value) async {
    await StorageService.setButtonColor(value);
    if (!mounted) return;
    setState(() => _buttonColor = value);
    widget.onCustomizationChanged?.call();
  }

  Future<void> _setSoundPreset(String value) async {
    await StorageService.setSoundPreset(value);
    if (!mounted) return;
    setState(() => _soundPreset = value);
    widget.onCustomizationChanged?.call();
  }

  Future<void> _setLocale(String value) async {
    await StorageService.setLocale(value);
    if (!mounted) return;
    setState(() => _locale = value);
    widget.onLocaleChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, l),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.theme,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                if (_loaded)
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'light',
                        label: Text(l.light),
                        icon: const Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: 'dark',
                        label: Text(l.dark),
                        icon: const Icon(Icons.dark_mode),
                      ),
                      ButtonSegment(
                        value: 'system',
                        label: Text(l.system),
                        icon: const Icon(Icons.brightness_auto),
                      ),
                    ],
                    selected: {_themeMode},
                    onSelectionChanged: (Set<String> s) => _setTheme(s.first),
                  ),
                const SizedBox(height: 24),
                Text(
                  l.accentColor,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _colorChip(context, 'red', Colors.red, l.classicRed),
                    const SizedBox(width: 12),
                    _colorChip(context, 'blue', Colors.blue, l.blue),
                    const SizedBox(width: 12),
                    _colorChip(context, 'green', Colors.green, l.green),
                    const SizedBox(width: 12),
                    _colorChip(context, 'yellow', Colors.orange, l.yellow),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l.audio,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'default',
                      label: Text(l.defaultSound),
                      icon: const Icon(Icons.volume_up),
                    ),
                    ButtonSegment(
                      value: 'classic',
                      label: Text(l.classicSound),
                      icon: const Icon(Icons.music_note),
                    ),
                  ],
                  selected: {_soundPreset},
                  onSelectionChanged: (Set<String> s) => _setSoundPreset(s.first),
                ),
                const SizedBox(height: 24),
                Text(
                  l.language,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _locale,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(l.languageSystem),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(l.english),
                    ),
                    DropdownMenuItem(
                      value: 'zh_TW',
                      child: Text(l.zhTW),
                    ),
                    DropdownMenuItem(
                      value: 'zh_CN',
                      child: Text(l.zhCN),
                    ),
                  ],
                  onChanged: (String? v) {
                    if (v != null) _setLocale(v);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorChip(BuildContext context, String id, Color color, String label) {
    final theme = Theme.of(context);
    final selected = _buttonColor == id;
    return InkWell(
      onTap: () => _setButtonColor(id),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: selected ? 3 : 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 8, 12),
      child: Row(
        children: [
          Text(
            l.settingsTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: l.close,
          ),
        ],
      ),
    );
  }
}
