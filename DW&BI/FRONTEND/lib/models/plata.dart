import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Plata {
  final int id;
  final int idRezervare;
  final double suma;
  final DateTime dataPlata;
  final String metoda;

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

  static void showAddPlataDialog(BuildContext context, OLTPViewModel vm) {
    int idRezervare = 0;
    double suma = 0.0;
    DateTime? dataPlata;
    String metoda = 'Cash';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Plata"),
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
              DropdownButton<String>(
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
              child: Text("Anuleaza")),
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
            child: Text("Salveaza"),
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
    String metoda = vm.plati[index].metoda;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Plata"),
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
              DropdownButton<String>(
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
              child: Text("Anuleaza")),
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
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }
}
