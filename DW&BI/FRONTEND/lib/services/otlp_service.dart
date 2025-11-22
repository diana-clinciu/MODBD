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

  OtlpService() {
    _loadMockData();
  }

  void _loadMockData() {
    clients = [
      Client(id: 1, nume: "Popescu", prenume: "Ana", email: "ana.popescu@email.ro"),
      Client(id: 2, nume: "Ionescu", prenume: "Maria", email: "maria.ionescu@email.ro"),
    ];
    rezervari = [
      Rezervare(id: 1, clientName: "Popescu Ana", data: DateTime(2025, 12, 1)),
      Rezervare(id: 2, clientName: "Ionescu Maria", data: DateTime(2025, 12, 3)),
    ];
    camere = [
      Camera(nr: 101, tip: "Single", pret: 150),
      Camera(nr: 102, tip: "Double", pret: 250),
    ];
    servicii = [
      Serviciu(denumire: "Spa", pret: 150),
      Serviciu(denumire: "Room Service", pret: 50),
    ];
    plati = [
      Plata(id: 1, suma: 450, metoda: "Card"),
      Plata(id: 2, suma: 500, metoda: "Cash"),
    ];
    angajati = [
      Angajat(nume: "Popa Andrei", functie: "Recepționer"),
      Angajat(nume: "Ionescu Mihai", functie: "Bucătar Șef"),
    ];
    evenimente = [
      Eveniment(nume: "Concert Rock", data: DateTime(2025, 12, 1)),
      Eveniment(nume: "Festival Jazz", data: DateTime(2025, 12, 5)),
    ];
  }

  // CLIENT CRUD
  void addClient(Client client) {
    clients.add(client);
  }

  void editClient(int index, Client updatedClient) {
    clients[index] = updatedClient;
  }

  void deleteClient(int index) {
    clients.removeAt(index);
  }

  // CAMERA CRUD
  void addCamera(Camera camera) {
    camere.add(camera);
  }

  void editCamera(int index, Camera updatedCamera) {
    camere[index] = updatedCamera;
  }

  void deleteCamera(int index) {
    camere.removeAt(index);
  }

  // REZERVARE CRUD
  void addRezervare(Rezervare rezervare) {
    rezervari.add(rezervare);
  }

  void editRezervare(int index, Rezervare updatedRezervare) {
    rezervari[index] = updatedRezervare;
  }

  void deleteRezervare(int index) {
    rezervari.removeAt(index);
  }

  // SERVICIU CRUD
  void addServiciu(Serviciu serviciu) {
    servicii.add(serviciu);
  }

  void editServiciu(int index, Serviciu updatedServiciu) {
    servicii[index] = updatedServiciu;
  }

  void deleteServiciu(int index) {
    servicii.removeAt(index);
  }

  // PLATA CRUD
  void addPlata(Plata plata) {
    plati.add(plata);
  }

  void editPlata(int index, Plata updatedPlata) {
    plati[index] = updatedPlata;
  }

  void deletePlata(int index) {
    plati.removeAt(index);
  }

  // ANGAJAT CRUD
  void addAngajat(Angajat angajat) {
    angajati.add(angajat);
  }

  void editAngajat(int index, Angajat updatedAngajat) {
    angajati[index] = updatedAngajat;
  }

  void deleteAngajat(int index) {
    angajati.removeAt(index);
  }

  // EVENIMENT CRUD
  void addEveniment(Eveniment eveniment) {
    evenimente.add(eveniment);
  }

  void editEveniment(int index, Eveniment updatedEveniment) {
    evenimente[index] = updatedEveniment;
  }

  void deleteEveniment(int index) {
    evenimente.removeAt(index);
  }
}
