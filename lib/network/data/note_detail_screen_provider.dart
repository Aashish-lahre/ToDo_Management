import 'package:flutter/material.dart';

class NoteDetailScreenProvider with ChangeNotifier {

  late int _index;
  int get index {
    return _index;
  }

  void setIndex(int noteIndex) {
    _index = noteIndex;

    notifyListeners();
  }
}