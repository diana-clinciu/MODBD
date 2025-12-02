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

  Future<List<Angajat>> fetchAngajati() async {
    final angajati = await bookingApi.fetchAngajati();
    return angajati;
  }

  Future<List<Eveniment>> fetchEvenimente() async {
    final evenimente = await bookingApi.fetchEvenimente();
    return evenimente;
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
  Future<Angajat> addAngajat(Angajat angajat) async {
    final addedAngajat = await bookingApi.addAngajat(angajat);
    return addedAngajat;
  }

  Future<Angajat> editAngajat(Angajat updatedAngajat) async {
    final updated = await bookingApi.updateAngajat(updatedAngajat);
    return updated;
  }

  Future<void> deleteAngajat(int id_angajat) async {
    await bookingApi.deleteAngajat(id_angajat);
  }

  // EVENIMENT CRUD
  Future<Eveniment> addEveniment(Eveniment eveniment) async {
    final addedEveniment = await bookingApi.addEveniment(eveniment);
    return addedEveniment;
  }

  Future<Eveniment> editEveniment(Eveniment updatedEveniment) async {
    final updated = await bookingApi.updateEveniment(updatedEveniment);
    return updated;
  }

  Future<void> deleteEveniment(int id_eveniment) async {
    await bookingApi.deleteEveniment(id_eveniment);
  }
}
