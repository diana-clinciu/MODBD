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
  List<Client> clients = [];
  List<Rezervare> rezervari = [];
  List<Camera> camere = [];
  List<Serviciu> servicii = [];
  List<Plata> plati = [];
  List<Angajat> angajati = [];
  List<Eveniment> evenimente = [];

  OLTPViewModel() {
    loadAll();
  }

  Future<void> loadAll() async {
    await loadClients();
    await loadRezervari();
    await loadCamere();
    // await loadServicii();
    // await loadPlati();
    // await loadAngajati();
    // await loadEvenimente();
  }

  Future<void> loadClients() async {
    clients = await otlpService.fetchClients();
    notifyListeners();
  }

  Future<void> loadRezervari() async {
    rezervari = await otlpService.fetchRezervari();
    notifyListeners();
  }

  Future<void> loadCamere() async {
    camere = await otlpService.fetchCamere();
    notifyListeners();
  }

  // CLIENT CRUD
  Future<void> addClient(Client client) async {
    final newClient = await otlpService.addClient(client);
    clients.add(newClient);
    notifyListeners();
  }

  Future<void> editClient(int index, Client updatedClient) async {
    final updated = await otlpService.editClient(updatedClient);
    clients[index] = updated;
    notifyListeners();
  }

  Future<void> deleteClient(int index) async {
    final id = clients[index].id;
    await otlpService.deleteClient(id);
    clients.removeAt(index);
    notifyListeners();
  }

  // REZERVARE CRUD
  Future<void> addRezervare(Rezervare rezervare) async {
    final newRezervare = await otlpService.addRezervare(rezervare);
    rezervari.add(newRezervare);
    notifyListeners();
  }

  Future<void> editRezervare(int index, Rezervare updatedRezervare) async {
    final updated = await otlpService.editRezervare(updatedRezervare);
    rezervari[index] = updated;
    notifyListeners();
  }

  Future<void> deleteRezervare(int index) async {
    final id = rezervari[index].id;
    await otlpService.deleteRezervare(id);
    rezervari.removeAt(index);
    notifyListeners();
  }

  // CAMERA CRUD
  Future<void> addCamera(Camera camera) async {
    final newCamera = await otlpService.addCamera(camera);
    camere.add(newCamera);
    notifyListeners();
  }

  Future<void> editCamera(int index, Camera updatedCamera) async {
    final updated = await otlpService.editCamera(updatedCamera);
    camere[index] = updated;
    notifyListeners();
  }

  Future<void> deleteCamera(int index) async {
    final id = camere[index].id;
    await otlpService.deleteCamera(id);
    camere.removeAt(index);
    notifyListeners();
  }

  // SERVICIU CRUD
  Future<void> addServiciu(Serviciu serviciu) async {
    await otlpService.addServiciu(serviciu);
    notifyListeners();
  }

  Future<void> editServiciu(int index, Serviciu updatedServiciu) async {
    await otlpService.editServiciu(index, updatedServiciu);
    notifyListeners();
  }

  Future<void> deleteServiciu(int index) async {
    await otlpService.deleteServiciu(index);
    notifyListeners();
  }

  // PLATA CRUD
  Future<void> addPlata(Plata plata) async {
    await otlpService.addPlata(plata);
    notifyListeners();
  }

  Future<void> editPlata(int index, Plata updatedPlata) async {
    await otlpService.editPlata(index, updatedPlata);
    notifyListeners();
  }

  Future<void> deletePlata(int index) async {
    await otlpService.deletePlata(index);
    notifyListeners();
  }

  // ANGAJAT CRUD
  Future<void> addAngajat(Angajat angajat) async {
    await otlpService.addAngajat(angajat);
    notifyListeners();
  }

  Future<void> editAngajat(int index, Angajat updatedAngajat) async {
    await otlpService.editAngajat(index, updatedAngajat);
    notifyListeners();
  }

  Future<void> deleteAngajat(int index) async {
    await otlpService.deleteAngajat(index);
    notifyListeners();
  }

  // EVENIMENT CRUD
  Future<void> addEveniment(Eveniment eveniment) async {
    await otlpService.addEveniment(eveniment);
    notifyListeners();
  }

  Future<void> editEveniment(int index, Eveniment updatedEveniment) async {
    await otlpService.editEveniment(index, updatedEveniment);
    notifyListeners();
  }

  Future<void> deleteEveniment(int index) async {
    await otlpService.deleteEveniment(index);
    notifyListeners();
  }
}
