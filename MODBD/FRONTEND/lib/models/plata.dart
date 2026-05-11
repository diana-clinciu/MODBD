import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';
import 'package:mvvm_flutter/utils/extensions/color+.dart';

class Plata {
  final int id;
  final int idRezervare;
  final double suma;
  final DateTime dataPlata;
  final String? metoda;

  Plata({
    required this.id,
    required this.idRezervare,
    required this.suma,
    required this.dataPlata,
    required this.metoda,
  });

  static Plata fromJson(JSON jsonBody) {
    return Plata(
      id: jsonBody["id_plata"],
      idRezervare: jsonBody["id_rezervare"],
      suma: jsonBody["suma"]?.toDouble() ?? 0.0,
      dataPlata: DateTime.parse(jsonBody["data_plata"]),
      metoda: jsonBody["metoda_plata"],
    );
  }

  Map<String, String> toFormFields() => {
        'id_plata': id.toString(),
        'id_rezervare': idRezervare.toString(),
        'suma': suma.toString(),
        'data_plata': dataPlata.toIso8601String().split('T')[0],
        if (metoda != null) 'metoda_plata': metoda!,
      };

  static Future<Plata?> showAddDialog(
          BuildContext context, List<Rezervare> rezervari) =>
      _showGenericDialog(context, null, rezervari);

  static Future<Plata?> showEditDialog(
          BuildContext context, Plata p, List<Rezervare> rezervari) =>
      _showGenericDialog(context, p, rezervari);

  static Future<Plata?> _showGenericDialog(
      BuildContext context, Plata? existing, List<Rezervare> rezervari) {
    final idCtrl = TextEditingController(text: existing?.id.toString() ?? '');
    final sumaCtrl = TextEditingController(text: existing?.suma.toString() ?? '');
    int? selectedRezervareId = existing?.idRezervare;
    DateTime dataPlata = existing?.dataPlata ?? DateTime.now();
    String metoda = existing?.metoda ?? 'Cash';

    return showDialog<Plata>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(existing == null ? 'Adauga Plata' : 'Editeaza Plata'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (existing == null)
                TextField(
                  controller: idCtrl,
                  decoration: const InputDecoration(labelText: 'ID Plata *'),
                  keyboardType: TextInputType.number,
                ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Rezervare *'),
                value: selectedRezervareId,
                items: rezervari
                    .map((r) => DropdownMenuItem(
                          value: r.id,
                          child: Text('Rezervare #${r.id}'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedRezervareId = v),
              ),
              TextField(
                controller: sumaCtrl,
                decoration: const InputDecoration(labelText: 'Suma (RON) *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              ListTile(
                dense: true,
                title: Text('Data: ${dataPlata.day}/${dataPlata.month}/${dataPlata.year}'),
                trailing: const Icon(Icons.calendar_today, size: 18),
                onTap: () async {
                  final p = await showDatePicker(
                      context: ctx,
                      initialDate: dataPlata,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (p != null) setState(() => dataPlata = p);
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Metoda'),
                value: metoda,
                items: ['Cash', 'Card', 'Transfer']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => metoda = v ?? 'Cash'),
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
                final suma = double.tryParse(sumaCtrl.text.trim());
                if (id == null || selectedRezervareId == null || suma == null) return;
                Navigator.pop(
                  ctx,
                  Plata(
                    id: id,
                    idRezervare: selectedRezervareId!,
                    suma: suma,
                    dataPlata: dataPlata,
                    metoda: metoda,
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

  static void showAddPlataDialog(BuildContext context, OLTPViewModel vm) {
    int idRezervare = 0;
    double suma = 0.0;
    DateTime? dataPlata;
    String? metoda = 'Cash';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga plata",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.blackForestColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: idRezervare != 0 ? idRezervare : null,
                hint: Text("Alege rezervarea"),
                items: vm.rezervari
                    .map((r) => DropdownMenuItem(
                          value: r.id,
                          child: Text("Rezervare #${r.id}"),
                        ))
                    .toList(),
                onChanged: (v) => idRezervare = v ?? 0,
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => suma = double.tryParse(v) ?? 0.0,
                decoration: InputDecoration(labelText: "Suma plata"),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(dataPlata != null
                        ? "${dataPlata!.day}/${dataPlata!.month}/${dataPlata!.year}"
                        : "Alege data plata"),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: dataPlata ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        dataPlata = picked;
                      }
                    },
                  ),
                ],
              ),
              DropdownButton<String?>(
                value: metoda,
                items: ['Cash', 'Card', 'Transfer']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => metoda = v ?? 'Cash',
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
                      color: AppColors.blackForestColor))),
          ElevatedButton(
            onPressed: () {
              if (dataPlata != null) {
                vm.addPlata(Plata(
                  id: vm.plati.length + 1,
                  idRezervare: idRezervare,
                  suma: suma,
                  dataPlata: dataPlata!,
                  metoda: metoda,
                ));
                Navigator.pop(dialogContext);
              }
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

  static void showEditPlataDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    int idRezervare = vm.plati[index].idRezervare;
    double suma = vm.plati[index].suma;
    DateTime dataPlata = vm.plati[index].dataPlata;
    String? metoda = vm.plati[index].metoda;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica plata",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.blackForestColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: idRezervare != 0 ? idRezervare : null,
                hint: Text("Alege rezervarea"),
                items: vm.rezervari
                    .map((r) => DropdownMenuItem(
                          value: r.id,
                          child: Text("Rezervare #${r.id}"),
                        ))
                    .toList(),
                onChanged: (v) => idRezervare = v ?? 0,
              ),
              TextField(
                controller: TextEditingController(text: suma.toString()),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => suma = double.tryParse(v) ?? 0.0,
                decoration: InputDecoration(labelText: "Suma plata"),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        "${dataPlata.day}/${dataPlata.month}/${dataPlata.year}"),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: dataPlata,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        dataPlata = picked;
                      }
                    },
                  ),
                ],
              ),
              DropdownButton<String?>(
                value: metoda,
                items: ['Cash', 'Card', 'Transfer']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => metoda = v ?? 'Cash',
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
                      color: AppColors.blackForestColor))),
          ElevatedButton(
            onPressed: () {
              vm.editPlata(
                index,
                Plata(
                  id: vm.plati[index].id,
                  idRezervare: idRezervare,
                  suma: suma,
                  dataPlata: dataPlata,
                  metoda: metoda,
                ),
              );
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
