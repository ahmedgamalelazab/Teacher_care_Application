//in this module we will implement a provider to exchange screens

import 'package:flutter/material.dart';

class ApplicationNavigationBarState extends ChangeNotifier {
  //private:
  int _currentIndex = 0;

  //public:

  //getter
  int getCurrentIndex() {
    return _currentIndex;
  }

  //setter
  void overLapScreen(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
