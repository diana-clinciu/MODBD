import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Rezervare {
  final int id;
  final int? clientId;
  String? clientName;
  final DateTime data;

  Rezervare({
    required this.id,
    this.clientName,
    this.clientId,
    required this.data,
  });

  static Rezervare fromJson(JSON jsonBody) {
    return Rezervare(
      id: jsonBody["id_rezervare"],
      clientId: jsonBody["id_client"],
      clientName: jsonBody["clientName"],
      data: DateTime.parse(jsonBody["data"]),
    );
  }

  static void showAddReservationDialog(BuildContext context, OLTPViewModel vm) {
    int? selectedClientId;
    DateTime data = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Rezervare"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: "Alege client"),
              items: vm.clients.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Text("${c.nume} ${c.prenume}"),
                );
              }).toList(),
              onChanged: (value) => selectedClientId = value,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text("${data.day}/${data.month}/${data.year}"),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: dialogContext,
                      initialDate: data,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      data = picked;
                    }
                  },
                ),
              ],
            ),
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
                  clientId: selectedClientId!,
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
    DateTime data = vm.rezervari[index].data;
    int? selectedClientId = vm.rezervari[index].clientId;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Rezervare"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: "Alege client"),
              value: selectedClientId,
              items: vm.clients.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Text("${c.nume} ${c.prenume}"),
                );
              }).toList(),
              onChanged: (value) => selectedClientId = value,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text("${data.day}/${data.month}/${data.year}"),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: dialogContext,
                      initialDate: data,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      data = picked;
                    }
                  },
                ),
              ],
            ),
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
                      clientId: selectedClientId!,
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
