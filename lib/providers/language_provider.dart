import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages language state with instant reactivity and persistent storage (default: Bahasa Indonesia 'id')
class LanguageProvider extends ChangeNotifier {
  static const String _prefKey = 'selected_locale';
  String _currentLocale = 'id';

  LanguageProvider() {
    _loadFromPrefs();
  }

  String get currentLocale => _currentLocale;
  bool get isIndonesian => _currentLocale == 'id';

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_prefKey);
      if (savedLocale != null && (savedLocale == 'id' || savedLocale == 'en')) {
        _currentLocale = savedLocale;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> setLocale(String locale) async {
    if (locale == 'id' || locale == 'en') {
      _currentLocale = locale;
      notifyListeners();
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_prefKey, locale);
      } catch (_) {}
    }
  }

  Future<void> toggleLanguage() async {
    final nextLocale = (_currentLocale == 'id') ? 'en' : 'id';
    await setLocale(nextLocale);
  }
}
