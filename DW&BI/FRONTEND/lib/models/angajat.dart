import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';
import 'package:mvvm_flutter/utils/extensions/color+.dart';

class Angajat {
  final int id;
  final String nume;
  final String prenume;
  final String functie;
  final double? salariu;
  final int idServiciu;

  Angajat({
    required this.id,
    required this.nume,
    required this.prenume,
    required this.functie,
    this.salariu,
    required this.idServiciu,
  });

  static Angajat fromJson(JSON jsonBody) {
    return Angajat(
      id: jsonBody["id_angajat"],
      nume: jsonBody["nume"],
      prenume: jsonBody["prenume"],
      functie: jsonBody["functie"],
      salariu: jsonBody["salariu"]?.toDouble(),
      idServiciu: jsonBody["id_serviciu"],
    );
  }

  static void showAddAngajatDialog(BuildContext context, OLTPViewModel vm) {
    String nume = '';
    String prenume = '';
    String functie = '';
    double? salariu;
    int? idServiciu;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          "Adauga angajat",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.blackForestColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (v) => nume = v,
                decoration: InputDecoration(labelText: "Nume"),
              ),
              TextField(
                onChanged: (v) => prenume = v,
                decoration: InputDecoration(labelText: "Prenume"),
              ),
              TextField(
                onChanged: (v) => functie = v,
                decoration: InputDecoration(labelText: "Functie"),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => salariu = double.tryParse(v),
                decoration: InputDecoration(labelText: "Salariu"),
              ),
              DropdownButton<int>(
                hint: Text("Alege serviciu"),
                value: idServiciu,
                items: vm.servicii
                    .map((s) => DropdownMenuItem(
                        value: s.id,
                        child: Text("${s.denumire} (${s.pret} RON)")))
                    .toList(),
                onChanged: (v) => idServiciu = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Anuleaza",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackForestColor)),
          ),
          ElevatedButton(
            onPressed: () {
              if (idServiciu != null) {
                vm.addAngajat(Angajat(
                  id: vm.angajati.length + 1,
                  nume: nume,
                  prenume: prenume,
                  functie: functie,
                  salariu: salariu,
                  idServiciu: idServiciu!,
                ));
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.lightCaramelColor.withTransparency(0.5),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Salveaza",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackForestColor)),
          ),
        ],
      ),
    );
  }

  static void showEditAngajatDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    Angajat a = vm.angajati[index];
    String nume = a.nume;
    String prenume = a.prenume;
    String functie = a.functie;
    double? salariu = a.salariu;
    int idServiciu = a.idServiciu;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica angajat",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.blackForestColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: nume),
                onChanged: (v) => nume = v,
                decoration: InputDecoration(labelText: "Nume"),
              ),
              TextField(
                controller: TextEditingController(text: prenume),
                onChanged: (v) => prenume = v,
                decoration: InputDecoration(labelText: "Prenume"),
              ),
              TextField(
                controller: TextEditingController(text: functie),
                onChanged: (v) => functie = v,
                decoration: InputDecoration(labelText: "Functie"),
              ),
              TextField(
                controller:
                    TextEditingController(text: salariu?.toString() ?? ""),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => salariu = double.tryParse(v),
                decoration: InputDecoration(labelText: "Salariu"),
              ),
              DropdownButton<int>(
                value: idServiciu,
                items: vm.servicii
                    .map((s) => DropdownMenuItem(
                        value: s.id,
                        child: Text("${s.denumire} (${s.pret} RON)")))
                    .toList(),
                onChanged: (v) => idServiciu = v ?? idServiciu,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackForestColor))),
          ElevatedButton(
            onPressed: () {
              vm.editAngajat(
                  index,
                  Angajat(
                    id: a.id,
                    nume: nume,
                    prenume: prenume,
                    functie: functie,
                    salariu: salariu,
                    idServiciu: idServiciu,
                  ));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.lightCaramelColor.withTransparency(0.5),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Salveaza",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackForestColor)),
          ),
        ],
      ),
    );
  }
}
