import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Serviciu {
  final int id;
  final String denumire;
  final double pret;

  Serviciu({required this.id, required this.denumire, required this.pret});

  static Serviciu fromJson(JSON jsonBody) {
    return Serviciu(id: jsonBody["id"], denumire: jsonBody["denumire"], pret: jsonBody["pret"]);
  }

  static void showAddCServiciuDialog(BuildContext context, OLTPViewModel vm) {
    String denumire = '';
    double pret = 0.0;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Serviciu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                onChanged: (v) => denumire = v,
                decoration: InputDecoration(labelText: "Denumire serviciu")),
            TextField(
                onChanged: (v) => pret = double.tryParse(v) ?? 0.0,
                decoration: InputDecoration(labelText: "Pret serviciu")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.addServiciu(Serviciu(id: vm.servicii.length + 1, denumire: denumire, pret: pret));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }

  static void showEditServiciuDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    String denumire = vm.servicii[index].denumire;
    double pret = vm.servicii[index].pret;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Serviciu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: TextEditingController(text: denumire),
                onChanged: (v) => denumire = v,
                decoration: InputDecoration(labelText: "Denumire serviciu")),
            TextField(
                controller: TextEditingController(text: pret.toString()),
                onChanged: (v) => pret = v as double,
                decoration: InputDecoration(labelText: "Pret serviciu")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.editServiciu(index, Serviciu(id: vm.servicii[index].id, denumire: denumire, pret: pret));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }
}
