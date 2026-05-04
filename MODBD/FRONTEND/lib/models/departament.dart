import 'package:flutter/material.dart';

class Departament {
  final int idDepartament;
  final String? numeDepartament;

  Departament({required this.idDepartament, required this.numeDepartament});

  factory Departament.fromJson(Map<String, dynamic> j) => Departament(
        idDepartament: j['id_departament'] as int,
        numeDepartament: j['nume_departament'] as String?,
      );

  Map<String, String> toFormFields() => {
        'id_departament': idDepartament.toString(),
        if (numeDepartament != null) 'nume_departament': numeDepartament!,
      };

  static Future<Departament?> showAddDialog(BuildContext context) =>
      _showDialog(context, null);

  static Future<Departament?> showEditDialog(BuildContext context, Departament d) =>
      _showDialog(context, d);

  static Future<Departament?> _showDialog(BuildContext context, Departament? existing) {
    final idCtrl = TextEditingController(text: existing?.idDepartament.toString() ?? '');
    final numeCtrl = TextEditingController(text: existing?.numeDepartament ?? '');

    return showDialog<Departament>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Adauga Departament' : 'Editeaza Departament'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: idCtrl,
            decoration: const InputDecoration(labelText: 'ID Departament *'),
            keyboardType: TextInputType.number,
            enabled: existing == null,
          ),
          TextField(
              controller: numeCtrl,
              decoration: const InputDecoration(labelText: 'Nume Departament *')),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Anuleaza')),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(idCtrl.text.trim());
              if (id == null || numeCtrl.text.trim().isEmpty) return;
              Navigator.pop(
                ctx,
                Departament(
                  idDepartament: existing?.idDepartament ?? id,
                  numeDepartament: numeCtrl.text.trim(),
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
  String toString() => numeDepartament ?? '';
}
