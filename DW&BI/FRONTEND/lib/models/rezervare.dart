import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Rezervare {
  final int id;
  final String clientName;
  final DateTime data;

  Rezervare({required this.id, required this.clientName, required this.data});

  static Rezervare fromJson(JSON jsonBody) {
    return Rezervare(
      id: jsonBody["id"],
      clientName: jsonBody["clientName"],
      data: DateTime.parse(jsonBody["data"]),
    );
  }

  static void showAddReservationDialog(BuildContext context, OLTPViewModel vm) {
    String clientName = '';
    DateTime data = DateTime.now(); //TODO: alexia - change to DateTime

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Rezervare"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                onChanged: (v) => clientName = v,
                decoration: InputDecoration(labelText: "Nume client")),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: data,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) data = picked;
              },
              child: Text("Selecteaza data"),
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.addRezervare(Rezervare(
                  id: vm.rezervari.length + 1,
                  clientName: clientName,
                  data: data));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }

  static void showEditReservationDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    String clientName = vm.rezervari[index].clientName;
    DateTime data = vm.rezervari[index].data;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Rezervare"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: clientName),
              onChanged: (v) => clientName = v,
              decoration: InputDecoration(labelText: "Nume client"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: data,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) data = picked;
              },
              child: Text("Selecteaza data"),
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.editRezervare(
                  index,
                  Rezervare(
                      id: vm.rezervari[index].id,
                      clientName: clientName,
                      data: data));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }
}
