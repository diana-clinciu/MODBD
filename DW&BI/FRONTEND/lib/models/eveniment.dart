import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Eveniment {
  final int id;
  final String nume;
  final DateTime data;
  final String? descriere;

  Eveniment({
    required this.id,
    required this.nume,
    required this.data,
    this.descriere,
  });

  static Eveniment fromJSON(JSON jsonBody) {
    return Eveniment(
      id: jsonBody["id_eveniment"],
      nume: jsonBody["nume_eveniment"],
      data: DateTime.parse(jsonBody["data_eveniment"]),
      descriere: jsonBody["descriere"],
    );
  }

  static void showAddEvenimentDialog(BuildContext context, OLTPViewModel vm) {
    String nume = '';
    String descriere = '';
    DateTime data = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Eveniment"),
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
            child: Text("Anuleaza"),
          ),
          ElevatedButton(
            onPressed: () {
              vm.addEveniment(Eveniment(
                id: vm.evenimente.length + 1,
                nume: nume,
                data: data,
                descriere: descriere.isEmpty ? null : descriere,
              ));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }

  static void showEditEvenimentDialog(BuildContext context, OLTPViewModel vm, int index) {
    String nume = vm.evenimente[index].nume;
    String? descriere = vm.evenimente[index].descriere;
    DateTime data = vm.evenimente[index].data;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Eveniment"),
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
            child: Text("Anuleaza"),
          ),
          ElevatedButton(
            onPressed: () {
              vm.editEveniment(index, Eveniment(
                id: vm.evenimente[index].id,
                nume: nume,
                data: data,
                descriere: descriere,
              ));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }
}
