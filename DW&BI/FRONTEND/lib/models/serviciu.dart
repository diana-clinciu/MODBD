import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Serviciu {
  final int id;
  final String denumire;
  final double pret;
  final DateTime? dataAchizitionare;
  final int? cantitate;

  Serviciu({
    required this.id,
    required this.denumire,
    required this.pret,
    this.dataAchizitionare,
    this.cantitate,
  });

  static Serviciu fromJson(JSON jsonBody) {
    return Serviciu(
      id: jsonBody["id"],
      denumire: jsonBody["denumire"],
      pret: jsonBody["pret"]?.toDouble() ?? 0.0,
      dataAchizitionare: jsonBody["data_achizitionare"] != null
          ? DateTime.tryParse(jsonBody["data_achizitionare"])
          : null,
      cantitate:
          jsonBody["cantitate"] != null ? jsonBody["cantitate"] as int : null,
    );
  }

  static void showAddServiciuDialog(BuildContext context, OLTPViewModel vm) {
    String denumire = '';
    double pret = 0.0;
    DateTime? dataAchizitionare;
    int? cantitate;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Serviciu"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (v) => denumire = v,
                decoration: InputDecoration(labelText: "Denumire serviciu"),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => pret = double.tryParse(v) ?? 0.0,
                decoration: InputDecoration(labelText: "Pret serviciu"),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dataAchizitionare,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) dataAchizitionare = picked;
                },
                child: Text("Selecteaza data"),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (v) => cantitate = int.tryParse(v),
                decoration: InputDecoration(labelText: "Cantitate"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Anuleaza"),
          ),
          ElevatedButton(
            onPressed: () {
              vm.addServiciu(
                Serviciu(
                  id: vm.servicii.length + 1,
                  denumire: denumire,
                  pret: pret,
                  dataAchizitionare: dataAchizitionare,
                  cantitate: cantitate,
                ),
              );
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
    DateTime? dataAchizitionare = vm.servicii[index].dataAchizitionare;
    int? cantitate = vm.servicii[index].cantitate;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Serviciu"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: denumire),
                onChanged: (v) => denumire = v,
                decoration: InputDecoration(labelText: "Denumire serviciu"),
              ),
              TextField(
                controller: TextEditingController(text: pret.toString()),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => pret = double.tryParse(v) ?? 0.0,
                decoration: InputDecoration(labelText: "Pret serviciu"),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dataAchizitionare,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) dataAchizitionare = picked;
                },
                child: Text("Selecteaza data"),
              ),
              TextField(
                controller: TextEditingController(
                    text: cantitate != null ? cantitate.toString() : ""),
                keyboardType: TextInputType.number,
                onChanged: (v) => cantitate = int.tryParse(v),
                decoration: InputDecoration(labelText: "Cantitate"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Anuleaza"),
          ),
          ElevatedButton(
            onPressed: () {
              vm.editServiciu(
                index,
                Serviciu(
                  id: vm.servicii[index].id,
                  denumire: denumire,
                  pret: pret,
                  dataAchizitionare: dataAchizitionare,
                  cantitate: cantitate,
                ),
              );
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }
}
