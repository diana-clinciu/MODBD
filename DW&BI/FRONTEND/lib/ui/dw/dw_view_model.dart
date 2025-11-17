import 'package:flutter/material.dart';

// MODELS MOCK DW
class DimClient {
  final int clientKey;
  final String nume;
  final String prenume;
  final String email;

  DimClient(this.clientKey, this.nume, this.prenume, this.email);
}

class DimCamera {
  final int cameraKey;
  final int nrCamera;
  final String tip;
  final double pret;

  DimCamera(this.cameraKey, this.nrCamera, this.tip, this.pret);
}

class DimServiciu {
  final int serviciuKey;
  final String denumire;
  final double pret;

  DimServiciu(this.serviciuKey, this.denumire, this.pret);
}

class DimEveniment {
  final int evenimentKey;
  final String nume;
  final DateTime data;

  DimEveniment(this.evenimentKey, this.nume, this.data);
}

class FactRezervari {
  final int rezervareKey;
  final String client;
  final String camera;
  final String serviciu;
  final String eveniment;
  final DateTime data;
  final double suma;

  FactRezervari(this.rezervareKey, this.client, this.camera, this.serviciu,
      this.eveniment, this.data, this.suma);
}

// VIEWMODEL DW
class DWViewModel extends ChangeNotifier {
  List<DimClient> dimClients = [];
  List<DimCamera> dimCamere = [];
  List<DimServiciu> dimServicii = [];
  List<DimEveniment> dimEvenimente = [];
  List<FactRezervari> factRezervari = [];

  String statusMessage = "Nicio propagare efectuată.";

  DWViewModel() {
    _loadMockData();
  }

  void _loadMockData() {
    // Dimensiuni
    dimClients = [
      DimClient(1, "Popescu", "Ana", "ana.popescu@email.ro"),
      DimClient(2, "Ionescu", "Maria", "maria.ionescu@email.ro"),
    ];

    dimCamere = [
      DimCamera(1, 101, "Single", 150),
      DimCamera(2, 102, "Double", 250),
    ];

    dimServicii = [
      DimServiciu(1, "Spa", 150),
      DimServiciu(2, "Room Service", 50),
    ];

    dimEvenimente = [
      DimEveniment(1, "Concert Rock", DateTime(2025, 12, 1)),
      DimEveniment(2, "Festival Jazz", DateTime(2025, 12, 5)),
    ];

    factRezervari = [
      FactRezervari(
          1, "Popescu Ana", "Single", "Spa", "Concert Rock", DateTime(2025, 12, 1), 450),
      FactRezervari(
          2, "Ionescu Maria", "Double", "Room Service", "Festival Jazz", DateTime(2025, 12, 3), 500),
    ];
  }

  void propagateChanges() {
    // simulare propagare cu delay
    statusMessage = "Se propagă modificările...";
    notifyListeners();

    Future.delayed(Duration(seconds: 2), () {
      statusMessage = "Propagare OLTP → DW finalizată cu succes!";
      notifyListeners();
    });
  }

  // Exemple de filtrare după client
  List<FactRezervari> filterFactByClient(String clientName) {
    return factRezervari
        .where((f) => f.client.toLowerCase().contains(clientName.toLowerCase()))
        .toList();
  }
}
