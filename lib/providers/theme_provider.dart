import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../hivedb/boxes.dart';
import '../hivedb/local_db.dart';

class ThemeProvider extends ChangeNotifier {
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  ThemeProvider() {
    loadThemeData();
  }

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    saveThemeData();
    notifyListeners();
  }

  void saveThemeData() async {
    final box = await Hive.openBox('themedata');
    final theme = DarkTheme()..darkTheme = _darkTheme;
    await box.put("darkTheme", theme);
    await box.close();
  }

  void loadThemeData() async {
    final box = await Hive.openBox('themedata');
    final data = box.get("darkTheme");
    if (data != null) {
      _darkTheme = data.darkTheme;
    }
    await box.close();
  }
}
