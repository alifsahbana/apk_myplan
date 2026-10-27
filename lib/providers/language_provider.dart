import 'package:flutter/material.dart';

/// Manages language state with instant reactivity (default: Bahasa Indonesia 'id')
class LanguageProvider extends ChangeNotifier {
  String _currentLocale = 'id';

  String get currentLocale => _currentLocale;
  bool get isIndonesian => _currentLocale == 'id';

  void setLocale(String locale) {
    if (locale == 'id' || locale == 'en') {
      _currentLocale = locale;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    _currentLocale = (_currentLocale == 'id') ? 'en' : 'id';
    notifyListeners();
  }
}
