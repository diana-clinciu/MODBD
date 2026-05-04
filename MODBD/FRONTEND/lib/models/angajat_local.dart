import 'package:flutter/material.dart';

class AngajatLocal {
  final int idAngajat;
  final String? nume;
  final String? prenume;
  final String? functie;
  final double? salariu;
  final int idDepartament;
  final int? idServiciu;
  final int idHotel;

  AngajatLocal({
    required this.idAngajat,
    required this.nume,
    required this.prenume,
    this.functie,
    this.salariu,
    required this.idDepartament,
    this.idServiciu,
    required this.idHotel,
  });

  factory AngajatLocal.fromJson(Map<String?, dynamic> j) => AngajatLocal(
        idAngajat: j['id_angajat'] as int,
        nume: j['nume'] as String?,
        prenume: j['prenume'] as String?,
        functie: j['functie'] as String?,
        salariu: j['salariu'] == null ? null : (j['salariu'] as num).toDouble(),
        idDepartament: j['id_departament'] as int,
        idServiciu: j['id_serviciu'] as int?,
        idHotel: j['id_hotel'] as int,
      );

  Map<String?, String?> toFormFields() => {
        'id_angajat': idAngajat.toString(),
        'nume': nume,
        'prenume': prenume,
        if (functie != null) 'functie': functie!,
        if (salariu != null) 'salariu': salariu.toString(),
        'id_departament': idDepartament.toString(),
        if (idServiciu != null) 'id_serviciu': idServiciu.toString(),
        'id_hotel': idHotel.toString(),
      };

  static Future<AngajatLocal?> showAddDialog(
          BuildContext context, int defaultIdHotel) =>
      _showDialog(context, null, defaultIdHotel);

  static Future<AngajatLocal?> showEditDialog(
          BuildContext context, AngajatLocal a) =>
      _showDialog(context, a, a.idHotel);

  static Future<AngajatLocal?> _showDialog(
      BuildContext context, AngajatLocal? existing, int defaultIdHotel) {
    final idCtrl = TextEditingController(
        text: existing?.idAngajat.toString() ?? '');
    final numeCtrl = TextEditingController(text: existing?.nume ?? '');
    final prenumeCtrl = TextEditingController(text: existing?.prenume ?? '');
    final functieCtrl = TextEditingController(text: existing?.functie ?? '');
    final salariuCtrl = TextEditingController(
        text: existing?.salariu?.toString() ?? '');
    final depCtrl = TextEditingController(
        text: existing?.idDepartament.toString() ?? '');
    final servCtrl = TextEditingController(
        text: existing?.idServiciu?.toString() ?? '');
    final hotelCtrl = TextEditingController(
        text: existing?.idHotel.toString() ?? defaultIdHotel.toString());

    return showDialog<AngajatLocal>(
      context: context,
      builder: (ctx) => AlertDialog(
        title:
            Text(existing == null ? 'Adauga Angajat' : 'Editeaza Angajat'),
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
                AngajatLocal(
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
