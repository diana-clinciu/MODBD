import 'package:mvvm_flutter/api/otlp_api.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/models/angajat.dart';
import 'package:mvvm_flutter/models/camera.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/eveniment.dart';
import 'package:mvvm_flutter/models/plata.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/serviciu.dart';

class OtlpService {
  final OtlpApi bookingApi = GetIt.instance.get<OtlpApi>();

  List<Client> clients = [];
  List<Rezervare> rezervari = [];
  List<Camera> camere = [];
  List<Serviciu> servicii = [];
  List<Plata> plati = [];
  List<Angajat> angajati = [];
  List<Eveniment> evenimente = [];

  Future<List<Client>> fetchClients() async {
    final response = await bookingApi.fetchClients();
    return response;
  }

  Future<List<Rezervare>> fetchRezervari() async {
    final response = await bookingApi.fetchRezervari();
    return response;
  }

  Future<void> loadCamere() async {
    // camere = await bookingApi.fetchCamere();
  }

  Future<void> loadServicii() async {
    servicii = await bookingApi.fetchServicii();
  }

  Future<void> loadPlati() async {
    plati = await bookingApi.fetchPlati();
  }

  Future<void> loadAngajati() async {
    angajati = await bookingApi.fetchAngajati();
  }

  Future<void> loadEvenimente() async {
    evenimente = await bookingApi.fetchEvenimente();
  }

  // CLIENT CRUD
  Future<Client> addClient(Client client) async {
    final addedClient = await bookingApi.addClient(client);
    return addedClient;
  }

  Future<Client> editClient(Client updatedClient) async {
    final updated = await bookingApi.updateClient(updatedClient);
    return updated;
  }

  Future<void> deleteClient(int id_client) async {
    await bookingApi.deleteClient(id_client);
  }

  // REZERVARE CRUD
  Future<Rezervare> addRezervare(Rezervare rezervare) async {
    final addedRezervare = await bookingApi.addRezervare(rezervare);
    return addedRezervare;
  }

  Future<Rezervare> editRezervare(Rezervare rezervare) async {
    final updatedRezervare = await bookingApi.updateRezervare(rezervare);
    return updatedRezervare;
  }

  Future<void> deleteRezervare(int id_rezervare) async {
    await bookingApi.deleteRezervare(id_rezervare);
  }

  // CAMERA CRUD
  Future<void> addCamera(Camera camera) async {
    await bookingApi.addCamera(camera);
    camere.add(camera);
  }

  Future<void> editCamera(int index, Camera updatedCamera) async {
    await bookingApi.updateCamera(updatedCamera);
    camere[index] = updatedCamera;
  }

  Future<void> deleteCamera(int index) async {
    await bookingApi.deleteCamera(camere[index].nr);
    camere.removeAt(index);
  }

  // SERVICIU CRUD
  Future<void> addServiciu(Serviciu serviciu) async {
    await bookingApi.addServiciu(serviciu);
    servicii.add(serviciu);
  }

  Future<void> editServiciu(int index, Serviciu updatedServiciu) async {
    await bookingApi.updateServiciu(updatedServiciu);
    servicii[index] = updatedServiciu;
  }

  Future<void> deleteServiciu(int index) async {
    await bookingApi.deleteServiciu(servicii[index].id);
    servicii.removeAt(index);
  }

  // PLATA CRUD
  Future<void> addPlata(Plata plata) async {
    await bookingApi.addPlata(plata);
    plati.add(plata);
  }

  Future<void> editPlata(int index, Plata updatedPlata) async {
    await bookingApi.updatePlata(updatedPlata);
    plati[index] = updatedPlata;
  }

  Future<void> deletePlata(int index) async {
    await bookingApi.deletePlata(plati[index].id);
    plati.removeAt(index);
  }

  // ANGAJAT CRUD
  Future<void> addAngajat(Angajat angajat) async {
    await bookingApi.addAngajat(angajat);
    angajati.add(angajat);
  }

  Future<void> editAngajat(int index, Angajat updatedAngajat) async {
    await bookingApi.updateAngajat(updatedAngajat);
    angajati[index] = updatedAngajat;
  }

  Future<void> deleteAngajat(int index) async {
    await bookingApi.deleteAngajat(angajati[index].id);
    angajati.removeAt(index);
  }

  // EVENIMENT CRUD
  Future<void> addEveniment(Eveniment eveniment) async {
    await bookingApi.addEveniment(eveniment);
    evenimente.add(eveniment);
  }

  Future<void> editEveniment(int index, Eveniment updatedEveniment) async {
    await bookingApi.updateEveniment(updatedEveniment);
    evenimente[index] = updatedEveniment;
  }

  Future<void> deleteEveniment(int index) async {
    await bookingApi.deleteEveniment(evenimente[index].id);
    evenimente.removeAt(index);
  }
}
