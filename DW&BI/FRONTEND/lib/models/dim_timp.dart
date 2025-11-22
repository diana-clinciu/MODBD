import 'package:mvvm_flutter/api/client_api.dart';

class DimTimp {
  final int timpKey;
  final DateTime dataCompleta;
  final int zi;
  final int luna;
  final int an;

  DimTimp({
    required this.timpKey,
    required this.dataCompleta,
    required this.zi,
    required this.luna,
    required this.an,
  });

  static DimTimp fromJson(JSON jsonBody) {
    return DimTimp(
      timpKey: jsonBody['timpKey'],
      dataCompleta: DateTime.parse(jsonBody['dataCompleta']),
      zi: jsonBody['zi'],
      luna: jsonBody['luna'],
      an: jsonBody['an'],
    );
  }
}
