import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class SettingsProvider extends ChangeNotifier {
  static const String _darkKey = 'isDarkMode';
  static const String _langKey = 'isEnglish';
  static const String _loginKey = 'isLoggedIn';

  bool _isDarkMode = false;
  bool _isEnglish = true;
  bool _isLoggedIn = false;
  String _userName = 'ياسر الصلوي';
  bool _loaded = false;

  bool get isDarkMode => _isDarkMode;
  bool get isEnglish => _isEnglish;
  bool get isArabic => !_isEnglish;
  bool get isLoaded => _loaded;

  // 👤 Auth State
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get displayName =>
      _isLoggedIn ? _userName : tr('عميل كار زون', 'CarZone Guest');

  // Global helpers so widgets don't need to repeat logic.
  Locale get locale => Locale(_isEnglish ? 'en' : 'ar');
  TextDirection get direction =>
      _isEnglish ? TextDirection.ltr : TextDirection.rtl;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Simple translation helper used by all screens.
  String tr(String ar, String en) => _isEnglish ? en : ar;

  SettingsProvider() {
    _loadPrefs();
  }

  // 👤 Auth Methods
  void setLoggedIn(bool value, [String name = 'ياسر الصلوي']) {
    _isLoggedIn = value;
    _userName = name;
    _saveBool(_loginKey, value);
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _saveBool(_loginKey, false);
    notifyListeners();
  }

  // 🌙 Dark Mode
  void toggleDarkMode() => setDarkMode(!_isDarkMode);

  void setDarkMode(bool value) {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    _saveBool(_darkKey, value);
    notifyListeners();
  }

  // 🌐 Language
  void toggleLanguage() => setLanguage(isEnglish: !_isEnglish);

  void setLanguage({required bool isEnglish}) {
    if (_isEnglish == isEnglish) return;
    _isEnglish = isEnglish;
    _saveBool(_langKey, isEnglish);
    notifyListeners();
  }

  // 💾 Load
  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final isArabic = deviceLocale.languageCode == 'ar';
    _isDarkMode = prefs.getBool(_darkKey) ?? false;
    _isEnglish = prefs.getBool(_langKey) ?? !isArabic;
    _isLoggedIn = prefs.getBool(_loginKey) ?? false;
    _loaded = true;
    notifyListeners();
  }

  // 💾 Save
  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
