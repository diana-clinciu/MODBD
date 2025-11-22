import 'package:mvvm_flutter/api/client_api.dart';

class DimMetodaPlata {
  final int plataKey;
  final String metoda;

  DimMetodaPlata({
    required this.plataKey,
    required this.metoda,
  });

  static DimMetodaPlata fromJson(JSON jsonBody) {
    return DimMetodaPlata(
      plataKey: jsonBody['plataKey'],
      metoda: jsonBody['metoda'],
    );
  }
}
