import 'package:flutter/material.dart';

enum AppTabType { local, global, statistici }

class TabViewViewModel extends ChangeNotifier {
  AppTabType _currentTab = AppTabType.local;
  AppTabType _activeTab = AppTabType.local;

  AppTabType _previousTab = AppTabType.local;

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
