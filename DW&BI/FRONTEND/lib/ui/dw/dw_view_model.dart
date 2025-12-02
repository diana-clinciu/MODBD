import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/services/dw_service.dart';

class DWViewModel extends ChangeNotifier {
  final DwService dwService = GetIt.instance.get<DwService>();

  bool isLoading = false;
  bool syncCompleted = false;

  Map<String, int> dwResults =
      {}; // Numarul de randuri propagate pe fiecare dimensiune

  Future<void> syncToDW() async {
    isLoading = true;
    syncCompleted = false;
    notifyListeners();

    try {
      final result = await dwService.syncDw();
      dwResults = result;
      filteredResults = Map.from(dwResults);
      syncCompleted = true;
    } catch (e) {
      syncCompleted = false;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<String, int> filteredResults = {};

  void filterResults(String query) {
    if (query.isEmpty) {
      filteredResults = Map.from(dwResults);
    } else {
      filteredResults = Map.fromEntries(
        dwResults.entries.where(
          (entry) => entry.key.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
    notifyListeners();
  }
}
