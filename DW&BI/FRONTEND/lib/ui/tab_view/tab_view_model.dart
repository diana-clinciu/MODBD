import 'package:flutter/material.dart';

enum AppTabType { otlp, dw, rapoarte }

class TabViewViewModel extends ChangeNotifier {
  AppTabType _currentTab = AppTabType.otlp;
  AppTabType _activeTab = AppTabType.otlp;
  // ignore: unused_field
  AppTabType _previousTab = AppTabType.otlp;

  AppTabType get currentTab => _currentTab;
  AppTabType get activeTab => _activeTab;

  int get currentIndex => AppTabType.values.indexOf(_currentTab);

  void selectTab(AppTabType tab) {
    _previousTab = _currentTab;
    _currentTab = tab;
    _activeTab = tab;

    notifyListeners();
  }

  void selectTabByIndex(int index) {
    if (index >= 0 && index < AppTabType.values.length) {
      selectTab(AppTabType.values[index]);
    }
  }
}
