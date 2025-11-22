import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/models/dim_camera.dart';
import 'package:mvvm_flutter/models/dim_client.dart';
import 'package:mvvm_flutter/models/dim_eveniment.dart';
import 'package:mvvm_flutter/models/dim_metoda_plata.dart';
import 'package:mvvm_flutter/models/dim_serviciu.dart';
import 'package:mvvm_flutter/models/dim_timp.dart';
import 'package:mvvm_flutter/models/fact_rezervari.dart';
import 'package:mvvm_flutter/services/dw_service.dart';
import 'package:mvvm_flutter/services/otlp_service.dart';

class DWViewModel extends ChangeNotifier {
  final OtlpService otlpService = GetIt.instance.get<OtlpService>();
  final DwService dwService = GetIt.instance.get<DwService>();

  List<DimClient> dimClients = [];
  List<DimCamera> dimCamere = [];
  List<DimServiciu> dimServicii = [];
  List<DimEveniment> dimEvenimente = [];
  List<DimTimp> dimTimp = [];
  List<DimMetodaPlata> dimMetodePlata = [];
  List<FactRezervari> factRezervari = [];

  String statusMessage = "Nicio propagare efectuată.";

  DWViewModel() {
    propagateChanges();
  }

  void propagateChanges() {
    statusMessage = "Se propagă modificările...";
    notifyListeners();

    Future.delayed(Duration(seconds: 2), () {
      dwService.updateFromOtlp(otlpService);

      dimClients = dwService.dimClients;
      dimCamere = dwService.dimCamere;
      dimServicii = dwService.dimServicii;
      dimEvenimente = dwService.dimEvenimente;
      dimTimp = dwService.dimTimp;
      dimMetodePlata = dwService.dimMetodePlata;
      factRezervari = dwService.factRezervari;

      statusMessage = "Propagare OLTP → DW finalizată cu succes!";
      notifyListeners();
    });
  }

  List<FactRezervari> filterFactByClient(String clientName) {
    return factRezervari
        .where((f) => f.client.toLowerCase().contains(clientName.toLowerCase()))
        .toList();
  }
}
