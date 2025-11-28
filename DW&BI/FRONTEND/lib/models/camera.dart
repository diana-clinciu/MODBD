import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';

class Camera {
  final int id;
  final int nr;
  final String tip;
  final double pret;

  Camera(
      {required this.id,
      required this.nr,
      required this.tip,
      required this.pret});

  static Camera fromJson(JSON jsonBody) {
    return Camera(
        id: jsonBody["id_camera"],
        nr: jsonBody["nr_camera"],
        tip: jsonBody["tip_camera"],
        pret: jsonBody["pret"]);
  }

  static void showAddCameraDialog(BuildContext context, OLTPViewModel vm) {
    int nr = 0;
    String tip = '';
    double pret = 0.0;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Adauga Camera"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (v) => nr = int.tryParse(v) ?? 0,
              decoration: InputDecoration(labelText: "Numar camera"),
            ),
            TextField(
                onChanged: (v) => tip = v,
                decoration: InputDecoration(labelText: "Tip camera")),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) => pret = double.tryParse(v) ?? 0.0,
              decoration: InputDecoration(labelText: "Pret camera"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.addCamera(Camera(
                  id: vm.camere.length + 1, nr: nr, tip: tip, pret: pret));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }

  static void showEditCameraDialog(
      BuildContext context, OLTPViewModel vm, int index) {
    int nr = vm.camere[index].nr;
    String tip = vm.camere[index].tip;
    double pret = vm.camere[index].pret;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Modifica Camera"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: nr.toString()),
              keyboardType: TextInputType.number,
              onChanged: (v) => nr = int.tryParse(v) ?? 0,
              decoration: InputDecoration(labelText: "Numar camera"),
            ),
            TextField(
              controller: TextEditingController(text: tip),
              onChanged: (v) => tip = v,
              decoration: InputDecoration(labelText: "Tip camera"),
            ),
            TextField(
              controller: TextEditingController(text: pret.toString()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) => pret = double.tryParse(v) ?? 0.0,
              decoration: InputDecoration(labelText: "Pret camera"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Anuleaza")),
          ElevatedButton(
            onPressed: () {
              vm.editCamera(
                  index,
                  Camera(
                      id: vm.camere[index].id, nr: nr, tip: tip, pret: pret));
              Navigator.pop(dialogContext);
            },
            child: Text("Salveaza"),
          ),
        ],
      ),
    );
  }
}
