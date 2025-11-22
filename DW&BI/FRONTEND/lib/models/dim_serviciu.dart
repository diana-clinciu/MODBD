import 'package:mvvm_flutter/api/client_api.dart';

class DimServiciu {
  final int serviciuKey;
  final String denumire;
  final double pret;

  DimServiciu(this.serviciuKey, this.denumire, this.pret);

  static DimServiciu fromJson(JSON jsonBody) {
    return DimServiciu(
      jsonBody['serviciuKey'],
      jsonBody['denumire'],
      jsonBody['pret'],
    );
  }
}