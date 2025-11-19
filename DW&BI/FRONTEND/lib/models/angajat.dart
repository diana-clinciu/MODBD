import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Angajat {
  final String nume;
  final String functie;

  Angajat({required this.nume, required this.functie});

  static Angajat fromJson(JSON jsonBody) {
    return Angajat(nume: jsonBody["nume"], functie: jsonBody["functie"]);
  }

  static void showAddAngajatDialog(BuildContext context, OLTPViewModel vm) {
    String nume = '';
    String functie = '';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Angajat"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                onChanged: (v) => nume = v,
                decoration: InputDecoration(labelText: "Nume angajat")),
            TextField(
                onChanged: (v) => functie = v,
                decoration: InputDecoration(labelText: "Functie angajat")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.addAngajat(Angajat(nume: nume, functie: functie));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }

  static void showEditAngajatDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    String nume = vm.angajati[index].nume;
    String functie = vm.angajati[index].functie;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Angajat"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: TextEditingController(text: nume),
                onChanged: (v) => nume = v,
                decoration: InputDecoration(labelText: "Nume angajat")),
            TextField(
                controller: TextEditingController(text: functie),
                onChanged: (v) => functie = v,
                decoration: InputDecoration(labelText: "Functie angajat")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.editAngajat(index, Angajat(nume: nume, functie: functie));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }
}
