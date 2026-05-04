import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';

class Serviciu {
  final int idServiciu;
  final String? denumire;
  final double pretServiciu;

  // Optional fields used in OLTP context
  final DateTime? dataAchizitionare;
  final int? cantitate;

  Serviciu({
    required this.idServiciu,
    required this.denumire,
    required this.pretServiciu,
    this.dataAchizitionare,
    this.cantitate,
  });

  factory Serviciu.fromJson(JSON j) => Serviciu(
        idServiciu: j['id_serviciu'] as int,
        denumire: j['denumire'] as String?,
        pretServiciu: (j['pret_serviciu'] as num).toDouble(),
      );

  // Alias used by OLTP screen
  double get pret => pretServiciu;

  Map<String, String> toFormFields() => {
        'id_serviciu': idServiciu.toString(),
        if (denumire != null) 'denumire': denumire!,
        'pret_serviciu': pretServiciu.toString(),
      };

  static Future<Serviciu?> showAddDialog(BuildContext context) =>
      _showDialog(context, null);

  static Future<Serviciu?> showEditDialog(BuildContext context, Serviciu s) =>
      _showDialog(context, s);

  static Future<Serviciu?> _showDialog(BuildContext context, Serviciu? existing) {
    final idCtrl = TextEditingController(text: existing?.idServiciu.toString() ?? '');
    final denCtrl = TextEditingController(text: existing?.denumire ?? '');
    final pretCtrl = TextEditingController(text: existing?.pretServiciu.toString() ?? '');

    return showDialog<Serviciu>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Adauga Serviciu' : 'Editeaza Serviciu'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'ID Serviciu *'),
              keyboardType: TextInputType.number,
              enabled: existing == null,
            ),
            TextField(
                controller: denCtrl,
                decoration: const InputDecoration(labelText: 'Denumire *')),
            TextField(
              controller: pretCtrl,
              decoration: const InputDecoration(labelText: 'Pret (RON) *'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Anuleaza')),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(idCtrl.text.trim());
              final pret = double.tryParse(pretCtrl.text.trim());
              if (id == null || denCtrl.text.trim().isEmpty || pret == null) return;
              Navigator.pop(
                ctx,
                Serviciu(
                  idServiciu: existing?.idServiciu ?? id,
                  denumire: denCtrl.text.trim(),
                  pretServiciu: pret,
                ),
              );
            },
            child: const Text('Salveaza'),
          ),
        ],
      ),
    );
  }

  @override
  String toString() => '${denumire ?? ''} (${pretServiciu.toStringAsFixed(2)} RON)';
}
