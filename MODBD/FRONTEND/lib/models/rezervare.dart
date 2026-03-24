import 'package:flutter/material.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';
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
              /// VALIDARE UI (foarte important)
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
    String label,
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
