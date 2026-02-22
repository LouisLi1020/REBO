import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _clickCountKey = 'click_count';
  static const String _highScoreKey = 'high_score';
  static const String _themeModeKey = 'theme_mode';
  static const String _themeModeLight = 'light';
  static const String _themeModeDark = 'dark';
  static const String _themeModeSystem = 'system';
  static const String _buttonColorKey = 'button_color';
  static const String _soundPresetKey = 'sound_preset';
  static const String _localeKey = 'locale';

  static final Map<String, int> _fallbackStorage = {
    _clickCountKey: 0,
    _highScoreKey: 0,
  };
  static String _fallbackThemeMode = _themeModeSystem;
  static String _fallbackButtonColor = 'red';
  static String _fallbackSoundPreset = 'default';
  static String _fallbackLocale = '';

  static Future<void> _handleStorageError(String operation, dynamic error) async {
    if (kDebugMode) {
      print('Storage error during $operation: $error');
    }
  }

  static Future<SharedPreferences?> _getPreferences() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (e) {
      await _handleStorageError('getPreferences', e);
      return null;
    }
  }

  static Future<void> incrementClickCount() async {
    try {
      final prefs = await _getPreferences();
      if (prefs == null) {
        _fallbackStorage[_clickCountKey] =
            (_fallbackStorage[_clickCountKey] ?? 0) + 1;
        if ((_fallbackStorage[_clickCountKey] ?? 0) >
            (_fallbackStorage[_highScoreKey] ?? 0)) {
          _fallbackStorage[_highScoreKey] = _fallbackStorage[_clickCountKey]!;
        }
        return;
      }
      final currentCount = prefs.getInt(_clickCountKey) ?? 0;
      final currentHighScore = prefs.getInt(_highScoreKey) ?? 0;
      await prefs.setInt(_clickCountKey, currentCount + 1);
      if (currentCount + 1 > currentHighScore) {
        await prefs.setInt(_highScoreKey, currentCount + 1);
      }
    } catch (e) {
      await _handleStorageError('incrementClickCount', e);
    }
  }

  static Future<int> getClickCount() async {
    try {
      final prefs = await _getPreferences();
      if (prefs == null) return _fallbackStorage[_clickCountKey] ?? 0;
      return prefs.getInt(_clickCountKey) ?? 0;
    } catch (e) {
      await _handleStorageError('getClickCount', e);
      return _fallbackStorage[_clickCountKey] ?? 0;
    }
  }

  static Future<int> getHighScore() async {
    try {
      final prefs = await _getPreferences();
      if (prefs == null) return _fallbackStorage[_highScoreKey] ?? 0;
      return prefs.getInt(_highScoreKey) ?? 0;
    } catch (e) {
      await _handleStorageError('getHighScore', e);
      return _fallbackStorage[_highScoreKey] ?? 0;
    }
  }

  static Future<void> resetScores() async {
    try {
      final prefs = await _getPreferences();
      if (prefs == null) {
        _fallbackStorage[_clickCountKey] = 0;
        return;
      }
      await prefs.setInt(_clickCountKey, 0);
    } catch (e) {
      await _handleStorageError('resetScores', e);
      _fallbackStorage[_clickCountKey] = 0;
    }
  }

  static Future<String> getThemeMode() async {
    try {
      final prefs = await _getPreferences();
      if (prefs == null) return _fallbackThemeMode;
      return prefs.getString(_themeModeKey) ?? _themeModeSystem;
    } catch (e) {
      await _handleStorageError('getThemeMode', e);
      return _fallbackThemeMode;
    }
  }

  static Future<void> setThemeMode(String value) async {
    if (value != _themeModeLight &&
        value != _themeModeDark &&
        value != _themeModeSystem) {
      return;
    }
    _fallbackThemeMode = value;
    try {
      final prefs = await _getPreferences();
      if (prefs != null) await prefs.setString(_themeModeKey, value);
    } catch (e) {
      await _handleStorageError('setThemeMode', e);
    }
  }

  static Future<String> getButtonColor() async {
    try {
      final prefs = await _getPreferences();
      if (prefs == null) return _fallbackButtonColor;
      return prefs.getString(_buttonColorKey) ?? 'red';
    } catch (e) {
      await _handleStorageError('getButtonColor', e);
      return _fallbackButtonColor;
    }
  }

  static Future<void> setButtonColor(String value) async {
    _fallbackButtonColor = value;
    try {
      final prefs = await _getPreferences();
      if (prefs != null) await prefs.setString(_buttonColorKey, value);
    } catch (e) {
      await _handleStorageError('setButtonColor', e);
    }
  }

  static Future<String> getSoundPreset() async {
    try {
      final prefs = await _getPreferences();
      if (prefs == null) return _fallbackSoundPreset;
      return prefs.getString(_soundPresetKey) ?? 'default';
    } catch (e) {
      await _handleStorageError('getSoundPreset', e);
      return _fallbackSoundPreset;
    }
  }

  static Future<void> setSoundPreset(String value) async {
    _fallbackSoundPreset = value;
    try {
      final prefs = await _getPreferences();
      if (prefs != null) await prefs.setString(_soundPresetKey, value);
    } catch (e) {
      await _handleStorageError('setSoundPreset', e);
    }
  }

  static Future<String> getLocale() async {
    try {
      final prefs = await _getPreferences();
      if (prefs == null) return _fallbackLocale;
      return prefs.getString(_localeKey) ?? _fallbackLocale;
    } catch (e) {
      await _handleStorageError('getLocale', e);
      return _fallbackLocale;
    }
  }

  static Future<void> setLocale(String value) async {
    _fallbackLocale = value;
    try {
      final prefs = await _getPreferences();
      if (prefs != null) await prefs.setString(_localeKey, value);
    } catch (e) {
      await _handleStorageError('setLocale', e);
    }
  }
}
