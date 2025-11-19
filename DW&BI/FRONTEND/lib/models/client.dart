import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Client {
  final int id;
  final String nume;
  final String prenume;
  final String email;

  Client(
      {required this.id,
      required this.nume,
      required this.prenume,
      required this.email});

  static Client fromJson(JSON jsonBody) {
    return Client(
        email: jsonBody["email"],
        id: jsonBody["id"],
        nume: jsonBody["nume"],
        prenume: jsonBody["prenume"]);
  }

  static void showAddClientDialog(BuildContext context, OLTPViewModel vm) {
    String nume = '';
    String prenume = '';
    String email = '';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Client"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                onChanged: (v) => nume = v,
                decoration: InputDecoration(labelText: "Nume")),
            TextField(
                onChanged: (v) => prenume = v,
                decoration: InputDecoration(labelText: "Prenume")),
            TextField(
                onChanged: (v) => email = v,
                decoration: InputDecoration(labelText: "Email")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.addClient(Client(id: vm.clients.length + 1, nume: nume, prenume: prenume, email: email));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }

  static void showEditClientDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    String nume = vm.clients[index].nume;
    String prenume = vm.clients[index].prenume;
    String email = vm.clients[index].email;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Client"),
        content: Column(
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
              controller: TextEditingController(text: email),
              onChanged: (v) => email = v,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.editClient(
                  index, Client(id: vm.clients[index].id, nume: nume, prenume: prenume, email: email));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }
}
