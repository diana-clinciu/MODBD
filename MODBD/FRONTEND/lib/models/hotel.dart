import 'package:flutter/material.dart';

class Hotel {
  final int idHotel;
  final String? numeHotel;
  final String? oras;
  final int? nrStele;
  final int? capacitate;

  Hotel({
    required this.idHotel,
    required this.numeHotel,
    required this.oras,
    this.nrStele,
    this.capacitate,
  });

  factory Hotel.fromJson(Map<String, dynamic> j) => Hotel(
        idHotel: j['id_hotel'] as int,
        numeHotel: j['nome_hotel'] as String?,
        oras: j['oras'] as String?,
        nrStele: j['nr_stele'] as int?,
        capacitate: j['capacitate'] as int?,
      );

  Map<String, String> toFormFields() => {
        'id_hotel': idHotel.toString(),
        if (numeHotel != null) 'nome_hotel': numeHotel!,
        if (oras != null) 'oras': oras!,
        if (nrStele != null) 'nr_stele': nrStele.toString(),
        if (capacitate != null) 'capacitate': capacitate.toString(),
      };

  static Future<Hotel?> showAddDialog(BuildContext context) =>
      _showDialog(context, null);

  static Future<Hotel?> showEditDialog(BuildContext context, Hotel hotel) =>
      _showDialog(context, hotel);

  static Future<Hotel?> _showDialog(BuildContext context, Hotel? existing) {
    final idCtrl = TextEditingController(
        text: existing?.idHotel.toString() ?? '');
    final numeCtrl = TextEditingController(text: existing?.numeHotel ?? '');
    final orasCtrl = TextEditingController(text: existing?.oras ?? '');
    final steleCtrl = TextEditingController(
        text: existing?.nrStele?.toString() ?? '');
    final capCtrl = TextEditingController(
        text: existing?.capacitate?.toString() ?? '');

    return showDialog<Hotel>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Adauga Hotel' : 'Editeaza Hotel'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'ID Hotel *'),
              keyboardType: TextInputType.number,
              enabled: existing == null,
            ),
            TextField(
                controller: numeCtrl,
                decoration: const InputDecoration(labelText: 'Nume Hotel *')),
            TextField(
                controller: orasCtrl,
                decoration: const InputDecoration(labelText: 'Oras *')),
            TextField(
              controller: steleCtrl,
              decoration: const InputDecoration(labelText: 'Nr Stele'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: capCtrl,
              decoration: const InputDecoration(labelText: 'Capacitate'),
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
              if (id == null || numeCtrl.text.trim().isEmpty ||
                  orasCtrl.text.trim().isEmpty) return;
              Navigator.pop(
                ctx,
                Hotel(
                  idHotel: existing?.idHotel ?? id,
                  numeHotel: numeCtrl.text.trim(),
                  oras: orasCtrl.text.trim(),
                  nrStele: int.tryParse(steleCtrl.text),
                  capacitate: int.tryParse(capCtrl.text),
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
