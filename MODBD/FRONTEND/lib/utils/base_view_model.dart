import 'dart:async';

import 'package:flutter/material.dart';

sealed class DefaultViewModelEvent {}

class DefaultViewModelSuccess extends DefaultViewModelEvent {}

class DefaultViewModelFailure<T> extends DefaultViewModelEvent {
  final T error;
  DefaultViewModelFailure(this.error);
}

class BaseViewModel<T> extends ChangeNotifier {
  final _eventController = StreamController<T>.broadcast();
  Stream<T> get events => _eventController.stream;

  Set<StreamSubscription> _subscriptions = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void emmitEvent(T event) {
    _eventController.add(event);
  }

  void watchStream<S>(
      {required Stream<S> stream, required void Function(S output) onReceive}) {
    final subscription = stream.listen((data) {
      onReceive(data);
    });
    _subscriptions.add(subscription);
  }

  void onEventReceived(void Function(T event) completionHandler) {
    final subscription = events.listen(completionHandler);
    _subscriptions.add(subscription);
  }

  @override
  void dispose() {
    _eventController.close();
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }
}
