import 'package:mvvm_flutter/api/client_api.dart';

class Serviciu {
  final int idServiciu;
  final String? denumire;
  final double pretServiciu;

  Serviciu({
    required this.idServiciu,
    required this.denumire,
    required this.pretServiciu,
  });

  factory Serviciu.fromJson(JSON j) => Serviciu(
        idServiciu: j['id_serviciu'] as int,
        denumire: j['denumire'] as String?,
        pretServiciu: (j['pret_serviciu'] as num).toDouble(),
      );

  @override
  String toString() => '${denumire ?? ''} (${pretServiciu.toStringAsFixed(2)} RON)';
}
