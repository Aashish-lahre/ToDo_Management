import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  final boxName = 'ThemeBox';
  ThemeProvider() {
    fetchThemeData();
  }


   ThemeMode _themeMode = ThemeMode.system;
  int _themeInt = 2;

  ThemeMode get themeMode {
    return _themeMode;
}

  int get themeInt {
    return _themeInt;
  }


  Future<Box<int>> openBox() async {
    if(Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    } else {
      return await Hive.openBox(boxName);
    }
  }

  void mapMode(int modeInt) {
    switch (modeInt) {
      case 0:
        _themeMode = ThemeMode.light;
        _themeInt = 0;
        break;
      case 1:
        _themeMode = ThemeMode.dark;
        _themeInt = 1;
        break;
      case 2:
        _themeMode = ThemeMode.system;
        _themeInt = 2;
        break;
    }
  }

  Future<void> fetchThemeData() async {
    final box = await openBox();
    if(box.get('mode') != null) {
      mapMode(box.get('mode')!);
    } else {
      box.put('mode', 2);
      mapMode(box.get('mode')!);
    }

    notifyListeners();
  }


  Future<void> editThemeMode(int modeInt) async {
    final box = await openBox();

    box.put('mode', modeInt);
    fetchThemeData();
  }




}