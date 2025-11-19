import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Eveniment {
  final String nume;
  final DateTime data;

  Eveniment({required this.nume, required this.data});

  static Eveniment jsonJSON(JSON jsonBody) {
    return Eveniment(nume: jsonBody["nume"], data: DateTime.parse(jsonBody["data"]));
  }

  static void showAddEvenimentDialog(BuildContext context, OLTPViewModel vm) {
    String nume = '';
    DateTime data = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Eveniment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                onChanged: (v) => nume = v,
                decoration: InputDecoration(labelText: "Nume eveniment")),
            // TextField(
            //     onChanged: (v) => data = v,
            //     decoration: InputDecoration(labelText: "Data eveniment")), TODO: alexia - add date picker
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.addEveniment(Eveniment(nume: nume, data: data));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }

  static void showEditEvenimentDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    String nume = vm.evenimente[index].nume;
    DateTime data = vm.evenimente[index].data;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Eveniment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: TextEditingController(text: nume),
                onChanged: (v) => nume = v,
                decoration: InputDecoration(labelText: "Nume eveniment")),
            // TextField(
            //   controller: TextEditingController(text: data.toString()),
            //   onChanged: (v) => data = v,
            //   decoration: InputDecoration(labelText: "Data eveniment"),
            // ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.editEveniment(index, Eveniment(nume: nume, data: data));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }
}