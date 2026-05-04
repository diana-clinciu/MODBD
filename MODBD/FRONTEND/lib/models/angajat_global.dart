import 'package:flutter/material.dart';

class AngajatGlobal {
  final int idAngajat;
  final String? nume;
  final String? prenume;
  final String? functie;
  final double? salariu;
  final int idDepartament;
  final int? idServiciu;
  final int idHotel;
  final String? cnp;
  final String? dataAngajare;

  AngajatGlobal({
    required this.idAngajat,
    this.nume,
    this.prenume,
    this.functie,
    this.salariu,
    required this.idDepartament,
    this.idServiciu,
    required this.idHotel,
    this.cnp,
    this.dataAngajare,
  });

  factory AngajatGlobal.fromJson(Map<String, dynamic> j) => AngajatGlobal(
        idAngajat: j['id_angajat'] as int,
        nume: j['nume'] as String?,
        prenume: j['prenume'] as String?,
        functie: j['functie'] as String?,
        salariu:
            j['salariu'] == null ? null : (j['salariu'] as num).toDouble(),
        idDepartament: j['id_departament'] as int,
        idServiciu: j['id_serviciu'] as int?,
        idHotel: j['id_hotel'] as int,
        cnp: j['cnp'] as String?,
        dataAngajare: j['data_angajare']?.toString(),
      );

  Map<String, String> toFormFields() => {
        'id_angajat': idAngajat.toString(),
        if (nume != null) 'nume': nume!,
        if (prenume != null) 'prenume': prenume!,
        if (functie != null) 'functie': functie!,
        if (salariu != null) 'salariu': salariu.toString(),
        'id_departament': idDepartament.toString(),
        if (idServiciu != null) 'id_serviciu': idServiciu.toString(),
        'id_hotel': idHotel.toString(),
        if (cnp != null) 'cnp': cnp!,
        if (dataAngajare != null) 'data_angajare': dataAngajare!,
      };

  static Future<AngajatGlobal?> showAddDialog(BuildContext context,
          [int? defaultHotelId]) =>
      _showDialog(context, null, defaultHotelId: defaultHotelId);

  static Future<AngajatGlobal?> showEditDialog(
          BuildContext context, AngajatGlobal a) =>
      _showDialog(context, a);

  static Future<AngajatGlobal?> _showDialog(
      BuildContext context, AngajatGlobal? existing,
      {int? defaultHotelId}) {
    final idCtrl =
        TextEditingController(text: existing?.idAngajat.toString() ?? '');
    final numeCtrl = TextEditingController(text: existing?.nume ?? '');
    final prenumeCtrl =
        TextEditingController(text: existing?.prenume ?? '');
    final functieCtrl =
        TextEditingController(text: existing?.functie ?? '');
    final salariuCtrl =
        TextEditingController(text: existing?.salariu?.toString() ?? '');
    final depCtrl = TextEditingController(
        text: existing?.idDepartament.toString() ?? '');
    final servCtrl =
        TextEditingController(text: existing?.idServiciu?.toString() ?? '');
    final hotelCtrl = TextEditingController(
        text: existing?.idHotel.toString() ??
            defaultHotelId?.toString() ??
            '');
    final cnpCtrl = TextEditingController(text: existing?.cnp ?? '');
    final daCtrl =
        TextEditingController(text: existing?.dataAngajare ?? '');

    return showDialog<AngajatGlobal>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            existing == null ? 'Adauga Angajat' : 'Editeaza Angajat'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'ID Angajat *'),
              keyboardType: TextInputType.number,
              enabled: existing == null,
            ),
            TextField(
                controller: numeCtrl,
                decoration: const InputDecoration(labelText: 'Nume *')),
            TextField(
                controller: prenumeCtrl,
                decoration: const InputDecoration(labelText: 'Prenume *')),
            TextField(
                controller: functieCtrl,
                decoration: const InputDecoration(labelText: 'Functie')),
            TextField(
              controller: salariuCtrl,
              decoration: const InputDecoration(labelText: 'Salariu'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: depCtrl,
              decoration:
                  const InputDecoration(labelText: 'ID Departament *'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: servCtrl,
              decoration: const InputDecoration(labelText: 'ID Serviciu'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: hotelCtrl,
              decoration: const InputDecoration(labelText: 'ID Hotel *'),
              keyboardType: TextInputType.number,
            ),
            TextField(
                controller: cnpCtrl,
                decoration: const InputDecoration(labelText: 'CNP')),
            TextField(
                controller: daCtrl,
                decoration: const InputDecoration(
                    labelText: 'Data Angajare (YYYY-MM-DD)')),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Anuleaza')),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(idCtrl.text.trim());
              final dep = int.tryParse(depCtrl.text.trim());
              final hotel = int.tryParse(hotelCtrl.text.trim());
              if (id == null || numeCtrl.text.trim().isEmpty ||
                  prenumeCtrl.text.trim().isEmpty ||
                  dep == null || hotel == null) return;
              Navigator.pop(
                ctx,
                AngajatGlobal(
                  idAngajat: existing?.idAngajat ?? id,
                  nume: numeCtrl.text.trim(),
                  prenume: prenumeCtrl.text.trim(),
                  functie: functieCtrl.text.trim().isEmpty
                      ? null
                      : functieCtrl.text.trim(),
                  salariu: double.tryParse(salariuCtrl.text),
                  idDepartament: dep,
                  idServiciu: int.tryParse(servCtrl.text),
                  idHotel: hotel,
                  cnp: cnpCtrl.text.trim().isEmpty
                      ? null
                      : cnpCtrl.text.trim(),
                  dataAngajare: daCtrl.text.trim().isEmpty
                      ? null
                      : daCtrl.text.trim(),
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
