import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _clickCountKey = 'click_count';
  static const String _highScoreKey = 'high_score';

  static final Map<String, int> _fallbackStorage = {
    _clickCountKey: 0,
    _highScoreKey: 0,
  };

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
}
