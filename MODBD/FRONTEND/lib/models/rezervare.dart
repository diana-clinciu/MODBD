import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';
import 'package:mvvm_flutter/utils/extensions/color+.dart';

class Rezervare {
  final int id;
  final int? clientId;
  String? clientName;
  DateTime dataStart;
  DateTime dataFinal;

  Rezervare({
    required this.id,
    this.clientName,
    this.clientId,
    required this.dataStart,
    required this.dataFinal,
  });

  static Rezervare fromJson(JSON jsonBody) {
    return Rezervare(
      id: jsonBody["id_rezervare"],
      clientId: jsonBody["id_client"],
      clientName: jsonBody["clientName"],
      dataStart: DateTime.parse(jsonBody["data_start"]),
      dataFinal: DateTime.parse(jsonBody["data_final"]),
    );
  }

  Map<String, String> toFormFields() => {
        'id_rezervare': id.toString(),
        if (clientId != null) 'id_client': clientId.toString(),
        'data_start': dataStart.toIso8601String().split('T')[0],
        'data_final': dataFinal.toIso8601String().split('T')[0],
      };

  static Future<Rezervare?> showAddDialog(
          BuildContext context, List<Client> clients) =>
      _showGenericDialog(context, null, clients);

  static Future<Rezervare?> showEditDialog(
          BuildContext context, Rezervare r, List<Client> clients) =>
      _showGenericDialog(context, r, clients);

  static Future<Rezervare?> _showGenericDialog(
      BuildContext context, Rezervare? existing, List<Client> clients) {
    final idCtrl = TextEditingController(text: existing?.id.toString() ?? '');
    int? selectedClientId = existing?.clientId;
    DateTime dataStart = existing?.dataStart ?? DateTime.now();
    DateTime dataFinal = existing?.dataFinal ?? DateTime.now().add(const Duration(days: 1));

    return showDialog<Rezervare>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(existing == null ? 'Adauga Rezervare' : 'Editeaza Rezervare'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (existing == null)
                TextField(
                  controller: idCtrl,
                  decoration: const InputDecoration(labelText: 'ID Rezervare *'),
                  keyboardType: TextInputType.number,
                ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Client *'),
                value: selectedClientId,
                items: clients
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text('${c.nume} ${c.prenume}'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedClientId = v),
              ),
              const SizedBox(height: 8),
              ListTile(
                dense: true,
                title: Text('Start: ${dataStart.day}/${dataStart.month}/${dataStart.year}'),
                trailing: const Icon(Icons.calendar_today, size: 18),
                onTap: () async {
                  final p = await showDatePicker(
                      context: ctx,
                      initialDate: dataStart,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (p != null) setState(() => dataStart = p);
                },
              ),
              ListTile(
                dense: true,
                title: Text('Final: ${dataFinal.day}/${dataFinal.month}/${dataFinal.year}'),
                trailing: const Icon(Icons.calendar_today, size: 18),
                onTap: () async {
                  final p = await showDatePicker(
                      context: ctx,
                      initialDate: dataFinal,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (p != null) setState(() => dataFinal = p);
                },
              ),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Anuleaza')),
            ElevatedButton(
              onPressed: () {
                final id = existing?.id ?? int.tryParse(idCtrl.text.trim());
                if (id == null || selectedClientId == null) return;
                if (dataStart.isAfter(dataFinal)) return;
                Navigator.pop(
                  ctx,
                  Rezervare(
                    id: id,
                    clientId: selectedClientId,
                    dataStart: dataStart,
                    dataFinal: dataFinal,
                  ),
                );
              },
              child: const Text('Salveaza'),
            ),
          ],
        ),
      ),
    );
  }

  static void showAddReservationDialog(BuildContext context, OLTPViewModel vm) {
    int? selectedClientId;
    DateTime dataStart = DateTime.now();
    DateTime dataFinal = DateTime.now().add(Duration(days: 1));

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga rezervare"),
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
            _datePicker(
              dialogContext,
              "Data start",
              dataStart,
              (d) => dataStart = d,
            ),
            _datePicker(
              dialogContext,
              "Data final",
              dataFinal,
              (d) => dataFinal = d,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              vm.addRezervare(
                Rezervare(
                  id: 0,
                  clientId: selectedClientId!,
                  dataStart: dataStart,
                  dataFinal: dataFinal,
                ),
              );
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          )
        ],
      ),
    );
  }

  static void showEditReservationDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    DateTime dataStart = vm.rezervari[index].dataStart;
    DateTime dataFinal = vm.rezervari[index].dataFinal;
    int? selectedClientId = vm.rezervari[index].clientId;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          "Modifica rezervare",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.blackForestColor,
          ),
        ),
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
            _datePicker(
              dialogContext,
              "Data start",
              dataStart,
              (d) => dataStart = d,
            ),
            _datePicker(
              dialogContext,
              "Data final",
              dataFinal,
              (d) => dataFinal = d,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              "Anuleaza",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.blackForestColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {

              if (dataStart.isAfter(dataFinal)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Data start nu poate fi după data final")),
                );
                return;
              }

              vm.editRezervare(
                index,
                Rezervare(
                  id: vm.rezervari[index].id,
                  clientId: selectedClientId!,
                  dataStart: dataStart,
                  dataFinal: dataFinal,
                ),
              );

              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.lightCaramelColor.withTransparency(0.5),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Salveaza",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.blackForestColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _datePicker(
    BuildContext context,
    String? label,
    DateTime date,
    Function(DateTime) onPicked,
  ) {
    return Row(
      children: [
        Expanded(child: Text("$label: ${date.day}/${date.month}/${date.year}")),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) onPicked(picked);
          },
        ),
      ],
    );
  }
}
