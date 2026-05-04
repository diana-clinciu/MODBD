import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';

class Client {
  final int id;
  final String? nume;
  final String? prenume;
  final String? email;

  Client({
    required this.id,
    required this.nume,
    required this.prenume,
    this.email,
  });

  factory Client.fromJson(JSON j) => Client(
        id: j['id_client'] as int,
        nume: j['nume'] as String?,
        prenume: j['prenume'] as String?,
        email: j['email'] as String?,
      );

  Map<String, String> toFormFields() => {
        'id_client': id.toString(),
        if (nume != null) 'nume': nume!,
        if (prenume != null) 'prenume': prenume!,
        if (email != null) 'email': email!,
      };

  static Future<Client?> showAddDialog(BuildContext context) =>
      _showDialog(context, null);

  static Future<Client?> showEditDialog(BuildContext context, Client c) =>
      _showDialog(context, c);

  static Future<Client?> _showDialog(BuildContext context, Client? existing) {
    final idCtrl =
        TextEditingController(text: existing?.id.toString() ?? '');
    final numeCtrl = TextEditingController(text: existing?.nume ?? '');
    final prenumeCtrl =
        TextEditingController(text: existing?.prenume ?? '');
    final emailCtrl =
        TextEditingController(text: existing?.email ?? '');

    return showDialog<Client>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Adauga Client' : 'Editeaza Client'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'ID Client *'),
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
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email')),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Anuleaza')),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(idCtrl.text.trim());
              if (id == null ||
                  numeCtrl.text.trim().isEmpty ||
                  prenumeCtrl.text.trim().isEmpty) return;
              Navigator.pop(
                ctx,
                Client(
                  id: existing?.id ?? id,
                  nume: numeCtrl.text.trim(),
                  prenume: prenumeCtrl.text.trim(),
                  email: emailCtrl.text.trim().isEmpty
                      ? null
                      : emailCtrl.text.trim(),
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
