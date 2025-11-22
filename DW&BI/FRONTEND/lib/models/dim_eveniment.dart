import 'package:mvvm_flutter/api/client_api.dart';

class DimEveniment {
  final int evenimentKey;
  final String nume;
  final DateTime data;

  DimEveniment(this.evenimentKey, this.nume, this.data);

  static DimEveniment fromJson(JSON jsonBody) {
    return DimEveniment(
      jsonBody['evenimentKey'],
      jsonBody['nume'],
      DateTime.parse(jsonBody['data']),
    );
  }
}