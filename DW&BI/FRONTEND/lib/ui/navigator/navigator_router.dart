import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NavigationDestination {
  static const Uuid _uuid = Uuid();
  final String tag;
  final Widget child;

  NavigationDestination({required this.child, String? tag})
      : this.tag = tag ?? "destination_${_uuid.v4()}";
}

extension WidgetNavigatorExtension on Widget {
  NavigationDestination asNavigationDestination({String? tag}) {
    return NavigationDestination(tag: tag, child: this);
  }
}

class NavigationRouter extends RouterDelegate<List<NavigationDestination>>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<List<NavigationDestination>> {
  final List<NavigationDestination> _navigationStack = [];

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<NavigationDestination> get destinationStack =>
      List.unmodifiable(_navigationStack);

  void push(NavigationDestination destination) {
    _navigationStack.add(destination);
    notifyListeners();
  }

  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  void popLast() {
    if (_navigationStack.length > 1) {
      _navigationStack.removeLast();
      notifyListeners();
    }
  }

  void popToTag(String tag) {
    while (_navigationStack.length > 1 && _navigationStack.last.tag != tag) {
      _navigationStack.removeLast();
    }
    notifyListeners();
  }

  void replaceCurrentDestination(NavigationDestination newDestination) {
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
    }
    _navigationStack.add(newDestination);
    notifyListeners();
  }

  void replaceNavigationStack(List<NavigationDestination> newStack) {
    _navigationStack.clear();
    _navigationStack.addAll(newStack);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _navigationStack
          .map((page) => MaterialPage(
                key: ValueKey(page.tag),
                child: page.child,
              ))
          .toList(),
      onDidRemovePage: (page) {
        popLast();
      },
    );
  }

  @override
  Future<void> setNewRoutePath(
      List<NavigationDestination> configuration) async {
    _navigationStack.clear();
    _navigationStack.addAll(configuration);
  }
}
