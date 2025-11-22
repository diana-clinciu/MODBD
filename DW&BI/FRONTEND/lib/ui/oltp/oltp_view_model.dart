import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/models/angajat.dart';
import 'package:mvvm_flutter/models/camera.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/eveniment.dart';
import 'package:mvvm_flutter/models/plata.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/serviciu.dart';
import 'package:mvvm_flutter/services/otlp_service.dart';

class OLTPViewModel extends ChangeNotifier {
  final OtlpService otlpService = GetIt.instance.get<OtlpService>();

  List<Client> get clients => otlpService.clients;
  List<Rezervare> get rezervari => otlpService.rezervari;
  List<Camera> get camere => otlpService.camere;
  List<Serviciu> get servicii => otlpService.servicii;
  List<Plata> get plati => otlpService.plati;
  List<Angajat> get angajati => otlpService.angajati;
  List<Eveniment> get evenimente => otlpService.evenimente;

  // CLIENT CRUD
  void addClient(Client client) {
    otlpService.addClient(client);
    notifyListeners();
  }

  void editClient(int index, Client updatedClient) {
    otlpService.editClient(index, updatedClient);
    notifyListeners();
  }

  void deleteClient(int index) {
    otlpService.deleteClient(index);
    notifyListeners();
  }

  // CAMERA CRUD
  void addCamera(Camera camera) {
    otlpService.addCamera(camera);
    notifyListeners();
  }

  void editCamera(int index, Camera updatedCamera) {
    otlpService.editCamera(index, updatedCamera);
    notifyListeners();
  }

  void deleteCamera(int index) {
    otlpService.deleteCamera(index);
    notifyListeners();
  }

  // REZERVARE CRUD
  void addRezervare(Rezervare rezervare) {
    otlpService.addRezervare(rezervare);
    notifyListeners();
  }

  void editRezervare(int index, Rezervare updatedRezervare) {
    otlpService.editRezervare(index, updatedRezervare);
    notifyListeners();
  }

  void deleteRezervare(int index) {
    otlpService.deleteRezervare(index);
    notifyListeners();
  }

  // SERVICIU CRUD
  void addServiciu(Serviciu serviciu) {
    otlpService.addServiciu(serviciu);
    notifyListeners();
  }

  void editServiciu(int index, Serviciu updatedServiciu) {
    otlpService.editServiciu(index, updatedServiciu);
    notifyListeners();
  }

  void deleteServiciu(int index) {
    otlpService.deleteServiciu(index);
    notifyListeners();
  }

  // PLATA CRUD
  void addPlata(Plata plata) {
    otlpService.addPlata(plata);
    notifyListeners();
  }

  void editPlata(int index, Plata updatedPlata) {
    otlpService.editPlata(index, updatedPlata);
    notifyListeners();
  }

  void deletePlata(int index) {
    otlpService.deletePlata(index);
    notifyListeners();
  }

  // ANGAJAT CRUD
  void addAngajat(Angajat angajat) {
    otlpService.addAngajat(angajat);
    notifyListeners();
  }

  void editAngajat(int index, Angajat updatedAngajat) {
    otlpService.editAngajat(index, updatedAngajat);
    notifyListeners();
  }

  void deleteAngajat(int index) {
    otlpService.deleteAngajat(index);
    notifyListeners();
  }

  // EVENIMENT CRUD
  void addEveniment(Eveniment eveniment) {
    otlpService.addEveniment(eveniment);
    notifyListeners();
  }

  void editEveniment(int index, Eveniment updatedEveniment) {
    otlpService.editEveniment(index, updatedEveniment);
    notifyListeners();
  }

  void deleteEveniment(int index) {
    otlpService.deleteEveniment(index);
    notifyListeners();
  }
}
