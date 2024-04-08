import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  void changeAppThemeMode() {
    isDark = !isDark;

    notifyListeners();
  }
}
