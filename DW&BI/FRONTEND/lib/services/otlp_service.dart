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

  Future<List<Camera>> fetchCamere() async {
    final response = await bookingApi.fetchCamere();
    return response;
  }

  Future<List<Serviciu>> fetchServicii() async {
    final response = await bookingApi.fetchServicii();
    return response;
  }

  Future<List<Plata>> fetchPlati() async {
    final plati = await bookingApi.fetchPlati();
    return plati;
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
  Future<Camera> addCamera(Camera camera) async {
    final addedCamera = await bookingApi.addCamera(camera);
    return addedCamera;
  }

  Future<Camera> editCamera(Camera updatedCamera) async {
    final updated = await bookingApi.updateCamera(updatedCamera);
    return updated;
  }

  Future<void> deleteCamera(int id_camera) async {
    await bookingApi.deleteCamera(id_camera);
  }

  // SERVICIU CRUD
  Future<Serviciu> addServiciu(Serviciu serviciu) async {
    final addedServiciu = await bookingApi.addServiciu(serviciu);
    return addedServiciu;
  }

  Future<Serviciu> editServiciu(Serviciu updatedServiciu) async {
    final updated = await bookingApi.updateServiciu(updatedServiciu);
    return updated;
  }

  Future<void> deleteServiciu(int id_serviciu) async {
    await bookingApi.deleteServiciu(id_serviciu);
  }

  // PLATA CRUD
  Future<Plata> addPlata(Plata plata) async {
    final addedPlata = await bookingApi.addPlata(plata);
    return addedPlata;
  }

  Future<Plata> editPlata(Plata updatedPlata) async {
    final updated = await bookingApi.updatePlata(updatedPlata);
    return updated;
  }

  Future<void> deletePlata(int id_plata) async {
    await bookingApi.deletePlata(id_plata);
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
