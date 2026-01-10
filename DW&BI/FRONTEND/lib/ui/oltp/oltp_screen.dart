import 'package:flutter/material.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';
import 'package:mvvm_flutter/models/angajat.dart';
import 'package:mvvm_flutter/models/camera.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/eveniment.dart';
import 'package:mvvm_flutter/models/plata.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/serviciu.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';
import 'package:mvvm_flutter/utils/extensions/color+.dart';
import 'package:provider/provider.dart';

class OltpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OLTPViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("OLTP - Hotel Manager",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackForestColor)),
        ),
        body: Consumer<OLTPViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCrudSection(
                    context,
                    "Clienti",
                    vm.clients
                        .map((c) => "${c.nume} ${c.prenume} (${c.email})")
                        .toList(),
                    () => Client.showAddClientDialog(context, vm),
                    (index) => Client.showEditClientDialog(context, vm, index),
                    (index) => vm.deleteClient(index),
                  ),
                  _buildCrudSection(
                    context,
                    "Rezervari",
                    vm.rezervari
                        .map(
                          (c) => "${c.clientName} - "
                              "${c.dataStart.toShortDateString()} → "
                              "${c.dataFinal.toShortDateString()}",
                        )
                        .toList(),
                    () => Rezervare.showAddReservationDialog(context, vm),
                    (index) =>
                        Rezervare.showEditReservationDialog(context, vm, index),
                    (index) => vm.deleteRezervare(index),
                  ),
                  _buildCrudSection(
                    context,
                    "Camere",
                    vm.camere
                        .map((c) => "${c.nr} - ${c.pret} RON - ${c.tip}")
                        .toList(),
                    () => Camera.showAddCameraDialog(context, vm),
                    (index) => Camera.showEditCameraDialog(context, vm, index),
                    (index) => vm.deleteCamera(index),
                  ),
                  _buildCrudSection(
                    context,
                    "Servicii",
                    vm.servicii.map((c) {
                      String dataText = c.dataAchizitionare != null
                          ? "${c.dataAchizitionare!.day}/${c.dataAchizitionare!.month}/${c.dataAchizitionare!.year}"
                          : "N/A";
                      String cantText =
                          c.cantitate != null ? "${c.cantitate}" : "N/A";

                      return "${c.denumire} - ${c.pret} RON - Cantitate: $cantText - Data: $dataText";
                    }).toList(),
                    () => Serviciu.showAddServiciuDialog(context, vm),
                    (index) =>
                        Serviciu.showEditServiciuDialog(context, vm, index),
                    (index) => vm.deleteServiciu(index),
                  ),
                  _buildCrudSection(
                    context,
                    "Plati",
                    vm.plati.map((c) {
                      final dataStr =
                          "${c.dataPlata.day}/${c.dataPlata.month}/${c.dataPlata.year}";
                      return "Rezervare: ${c.idRezervare}, Suma: ${c.suma} RON, Data: $dataStr, Metoda: ${c.metoda}";
                    }).toList(),
                    () => Plata.showAddPlataDialog(context, vm),
                    (index) => Plata.showEditPlataDialog(context, vm, index),
                    (index) => vm.deletePlata(index),
                  ),
                  _buildCrudSection(
                    context,
                    "Angajati",
                    vm.angajati
                        .map((c) =>
                            "${c.nume} ${c.prenume} - Funcție: ${c.functie}, Salariu: ${c.salariu} RON, Serviciu ID: ${c.idServiciu}")
                        .toList(),
                    () => Angajat.showAddAngajatDialog(context, vm),
                    (index) =>
                        Angajat.showEditAngajatDialog(context, vm, index),
                    (index) => vm.deleteAngajat(index),
                  ),
                  _buildCrudSection(
                    context,
                    "Evenimente",
                    vm.evenimente
                        .map((e) =>
                            "${e.nume} - ${e.data.day}/${e.data.month}/${e.data.year} - ${e.descriere ?? ''}")
                        .toList(),
                    () => Eveniment.showAddEvenimentDialog(context, vm),
                    (index) =>
                        Eveniment.showEditEvenimentDialog(context, vm, index),
                    (index) => vm.deleteEveniment(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCrudSection(
    BuildContext context,
    String title,
    List<String> items,
    VoidCallback onAdd,
    void Function(int) onEdit,
    void Function(int) onDelete,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackForestColor)),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightCaramelColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Adauga",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackForestColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ...items.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.oliveColor.withTransparency(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.contentPrimary,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: AppColors.blackForestColor),
                            onPressed: () => onEdit(entry.key),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: AppColors.reddishBrownColor),
                            onPressed: () => onDelete(entry.key),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return "${this.day.toString().padLeft(2, '0')}/"
        "${this.month.toString().padLeft(2, '0')}/"
        "${this.year}";
  }
}
