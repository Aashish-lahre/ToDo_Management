import 'package:flutter/material.dart';

class HeaderLoadingProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }


  void updateIsLoading(bool newLoadingState) {
    if(_isLoading != newLoadingState) {
      _isLoading = newLoadingState;
    }
    notifyListeners();
  }
}