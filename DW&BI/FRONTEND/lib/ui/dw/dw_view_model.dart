import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/services/dw_service.dart';

class DWViewModel extends ChangeNotifier {
  final DwService dwService = GetIt.instance.get<DwService>();

  bool isLoading = false;
  bool syncCompleted = false;

  Map<String, int> insertedResults = {};
  Map<String, int> totalResults = {};
  Map<String, int> filteredInsertedResults = {};

  Future<void> syncToDW() async {
    isLoading = true;
    syncCompleted = false;
    notifyListeners();

    try {
      final result = await dwService.syncDw();

      insertedResults = {};
      totalResults = {};

      result.forEach((key, value) {
        if (key.endsWith('_inserted')) {
          insertedResults[key] = value;
        } else {
          totalResults[key] = value;
        }
      });

      filteredInsertedResults = Map.from(insertedResults);
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
      filteredInsertedResults = Map.from(insertedResults);
    } else {
      filteredInsertedResults = Map.fromEntries(
        insertedResults.entries.where(
          (entry) => entry.key.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
    notifyListeners();
  }
}
