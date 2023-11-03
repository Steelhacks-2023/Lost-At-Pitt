import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {

  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  // Currently we don't have a dark theme though. Future improvement
  toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
      ? ThemeMode.dark
      : ThemeMode.light;
    notifyListeners();
  }
}