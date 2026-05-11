import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';
import 'package:mvvm_flutter/utils/extensions/color+.dart';

class Eveniment {
  final int id;
  final String? nume;
  final DateTime data;
  final String? descriere;
  final int? idSalaEveniment;

  Eveniment({
    required this.id,
    required this.nume,
    required this.data,
    this.descriere,
    this.idSalaEveniment,
  });

  static Eveniment fromJSON(JSON jsonBody) {
    return Eveniment(
      id: jsonBody["id_eveniment"],
      nume: jsonBody["nume_eveniment"],
      data: DateTime.parse(jsonBody["data_eveniment"]),
      descriere: jsonBody["descriere"],
      idSalaEveniment: jsonBody["id_sala_eveniment"] as int?,
    );
  }

  Map<String, String> toFormFields() => {
        'id_eveniment': id.toString(),
        if (nume != null) 'nume_eveniment': nume!,
        'data_eveniment': data.toIso8601String().split('T')[0],
        if (descriere != null && descriere!.isNotEmpty) 'descriere': descriere!,
        if (idSalaEveniment != null) 'id_sala_eveniment': idSalaEveniment.toString(),
      };

  static Future<Eveniment?> showAddDialog(BuildContext context) =>
      _showGenericDialog(context, null);

  static Future<Eveniment?> showEditDialog(BuildContext context, Eveniment e) =>
      _showGenericDialog(context, e);

  static Future<Eveniment?> _showGenericDialog(BuildContext context, Eveniment? existing) {
    final idCtrl = TextEditingController(text: existing?.id.toString() ?? '');
    final numeCtrl = TextEditingController(text: existing?.nume ?? '');
    final descCtrl = TextEditingController(text: existing?.descriere ?? '');
    final salaCtrl = TextEditingController(text: existing?.idSalaEveniment?.toString() ?? '');
    DateTime data = existing?.data ?? DateTime.now();

    return showDialog<Eveniment>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(existing == null ? 'Adauga Eveniment' : 'Editeaza Eveniment'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (existing == null)
                TextField(
                  controller: idCtrl,
                  decoration: const InputDecoration(labelText: 'ID Eveniment *'),
                  keyboardType: TextInputType.number,
                ),
              TextField(controller: numeCtrl,
                  decoration: const InputDecoration(labelText: 'Nume Eveniment')),
              ListTile(
                dense: true,
                title: Text('Data: ${data.day}/${data.month}/${data.year}'),
                trailing: const Icon(Icons.calendar_today, size: 18),
                onTap: () async {
                  final p = await showDatePicker(
                      context: ctx,
                      initialDate: data,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (p != null) setState(() => data = p);
                },
              ),
              TextField(controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Descriere')),
              TextField(
                controller: salaCtrl,
                decoration: const InputDecoration(labelText: 'ID Sala Eveniment'),
                keyboardType: TextInputType.number,
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
                if (id == null) return;
                Navigator.pop(
                  ctx,
                  Eveniment(
                    id: id,
                    nume: numeCtrl.text.trim().isEmpty ? null : numeCtrl.text.trim(),
                    data: data,
                    descriere: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                    idSalaEveniment: int.tryParse(salaCtrl.text.trim()),
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

  static void showAddEvenimentDialog(BuildContext context, OLTPViewModel vm) {
    String? nume = '';
    String? descriere = '';
    DateTime data = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga eveniment",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.blackForestColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (v) => nume = v,
                decoration: InputDecoration(labelText: "Nume eveniment"),
              ),
              TextField(
                onChanged: (v) => descriere = v,
                decoration: InputDecoration(labelText: "Descriere (optional)"),
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
                      if (picked != null) data = picked;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Anuleaza",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackForestColor)),
          ),
          ElevatedButton(
            onPressed: () {
              vm.addEveniment(Eveniment(
                id: vm.evenimente.length + 1,
                nume: nume,
                data: data,
                descriere: (descriere ?? '').isEmpty ? null : descriere,
              ));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.lightCaramelColor.withTransparency(0.5),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Salveaza",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackForestColor)),
          ),
        ],
      ),
    );
  }

  static void showEditEvenimentDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    String? nume = vm.evenimente[index].nume;
    String? descriere = vm.evenimente[index].descriere;
    DateTime data = vm.evenimente[index].data;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica eveniment",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.blackForestColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: nume),
                onChanged: (v) => nume = v,
                decoration: InputDecoration(labelText: "Nume eveniment"),
              ),
              TextField(
                controller: TextEditingController(text: descriere ?? ''),
                onChanged: (v) => descriere = v,
                decoration: InputDecoration(labelText: "Descriere (optional)"),
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
                      if (picked != null) data = picked;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Anuleaza",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackForestColor)),
          ),
          ElevatedButton(
            onPressed: () {
              vm.editEveniment(
                  index,
                  Eveniment(
                    id: vm.evenimente[index].id,
                    nume: nume,
                    data: data,
                    descriere: descriere,
                  ));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.lightCaramelColor.withTransparency(0.5),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Salveaza",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackForestColor)),
          ),
        ],
      ),
    );
  }
}
