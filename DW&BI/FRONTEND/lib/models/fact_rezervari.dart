import 'package:mvvm_flutter/api/client_api.dart';

class FactRezervari {
  final int rezervareKey;
  final String client;
  final String camera;
  final String serviciu;
  final String eveniment;
  final DateTime data;
  final double suma;

  FactRezervari(this.rezervareKey, this.client, this.camera, this.serviciu,
      this.eveniment, this.data, this.suma);

  static FactRezervari fromJson(JSON jsonBody) {
    return FactRezervari(
      jsonBody["rezervareKey"],
      jsonBody["client"],
      jsonBody["camera"],
      jsonBody["serviciu"],
      jsonBody["eveniment"],
      DateTime.parse(jsonBody["data"]),
      jsonBody["suma"],
    );
  }
}