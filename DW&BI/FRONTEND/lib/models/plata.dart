import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Plata {
  final int id;
  final double suma;
  final String metoda;

  Plata({required this.id, required this.suma, required this.metoda});

  static Plata fromJson(JSON jsonBody) {
    return Plata(id: jsonBody["id"], suma: jsonBody["suma"], metoda: jsonBody["metoda"]);
  }

  static void showAddPlataDialog(BuildContext context, OLTPViewModel vm) {
    String metoda = '';
    double suma = 0.0;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Plata"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                onChanged: (v) => suma = v as double,
                decoration: InputDecoration(labelText: "Suma plata")),
            TextField(
                onChanged: (v) => metoda = v,
                decoration: InputDecoration(labelText: "Metoad de plata")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.addPlata(Plata(id: vm.plati.length + 1, suma: suma, metoda: metoda));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }

  static void showEditPlatiDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    String metoda = vm.plati[index].metoda;
    double suma = vm.plati[index].suma;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Plata"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: TextEditingController(text: metoda),
                onChanged: (v) => metoda = v,
                decoration: InputDecoration(labelText: "Metoda de plata")),
            TextField(
                controller: TextEditingController(text: suma.toString()),
                onChanged: (v) => suma = double.tryParse(v) ?? 0.0,
                decoration: InputDecoration(labelText: "Suma de plata")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.editPlata(index, Plata(id: vm.plati[index].id, suma: suma, metoda: metoda));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }
}
