import 'package:flutter/material.dart';

class SalaEveniment {
  final int idSala;
  final String? numeSala;
  final int? capacitateMaxima;
  final int? etaj;

  SalaEveniment({
    required this.idSala,
    this.numeSala,
    this.capacitateMaxima,
    this.etaj,
  });

  factory SalaEveniment.fromJson(Map<String, dynamic> j) => SalaEveniment(
        idSala: j['id_sala_eveniment'] as int,
        numeSala: j['nume_sala'] as String?,
        capacitateMaxima: j['capacitate_maxima'] as int?,
        etaj: j['etaj'] as int?,
      );

  Map<String, String> toFormFields() => {
        'id_sala_eveniment': idSala.toString(),
        if (numeSala != null) 'nume_sala': numeSala!,
        if (capacitateMaxima != null) 'capacitate_maxima': capacitateMaxima.toString(),
        if (etaj != null) 'etaj': etaj.toString(),
      };

  static Future<SalaEveniment?> showAddDialog(BuildContext context) =>
      _showDialog(context, null);

  static Future<SalaEveniment?> showEditDialog(BuildContext context, SalaEveniment s) =>
      _showDialog(context, s);

  static Future<SalaEveniment?> _showDialog(BuildContext context, SalaEveniment? existing) {
    final idCtrl = TextEditingController(text: existing?.idSala.toString() ?? '');
    final numeCtrl = TextEditingController(text: existing?.numeSala ?? '');
    final capCtrl = TextEditingController(text: existing?.capacitateMaxima?.toString() ?? '');
    final etajCtrl = TextEditingController(text: existing?.etaj?.toString() ?? '');

    return showDialog<SalaEveniment>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Adauga Sala Eveniment' : 'Editeaza Sala Eveniment'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'ID Sala *'),
              keyboardType: TextInputType.number,
              enabled: existing == null,
            ),
            TextField(
                controller: numeCtrl,
                decoration: const InputDecoration(labelText: 'Nume Sala')),
            TextField(
              controller: capCtrl,
              decoration: const InputDecoration(labelText: 'Capacitate Maxima'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: etajCtrl,
              decoration: const InputDecoration(labelText: 'Etaj'),
              keyboardType: TextInputType.number,
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
              if (id == null) return;
              Navigator.pop(
                ctx,
                SalaEveniment(
                  idSala: existing?.idSala ?? id,
                  numeSala: numeCtrl.text.trim().isEmpty ? null : numeCtrl.text.trim(),
                  capacitateMaxima: int.tryParse(capCtrl.text),
                  etaj: int.tryParse(etajCtrl.text),
                ),
              );
            },
            child: const Text('Salveaza'),
          ),
        ],
      ),
    );
  }
}
