import 'package:flutter/material.dart';

// MODELS MOCK
class Client {
  final int id;
  final String nume;
  final String prenume;
  final String email;

  Client(this.id, this.nume, this.prenume, this.email);
}

class Rezervare {
  final int id;
  final String clientName;
  final DateTime data;

  Rezervare(this.id, this.clientName, this.data);
}

class Camera {
  final int nr;
  final String tip;
  final double pret;

  Camera(this.nr, this.tip, this.pret);
}

class Serviciu {
  final String denumire;
  final double pret;

  Serviciu(this.denumire, this.pret);
}

class Plata {
  final int id;
  final double suma;
  final String metoda;

  Plata(this.id, this.suma, this.metoda);
}

class Angajat {
  final String nume;
  final String functie;

  Angajat(this.nume, this.functie);
}

class Eveniment {
  final String nume;
  final DateTime data;

  Eveniment(this.nume, this.data);
}

// VIEWMODEL
class OLTPViewModel extends ChangeNotifier {
  List<Client> clients = [];
  List<Rezervare> rezervari = [];
  List<Camera> camere = [];
  List<Serviciu> servicii = [];
  List<Plata> plati = [];
  List<Angajat> angajati = [];
  List<Eveniment> evenimente = [];

  OLTPViewModel() {
    _loadMockData();
  }

  void _loadMockData() {
    clients = [
      Client(1, "Popescu", "Ana", "ana.popescu@email.ro"),
      Client(2, "Ionescu", "Maria", "maria.ionescu@email.ro"),
    ];

    rezervari = [
      Rezervare(1, "Popescu Ana", DateTime(2025, 12, 1)),
      Rezervare(2, "Ionescu Maria", DateTime(2025, 12, 3)),
    ];

    camere = [
      Camera(101, "Single", 150),
      Camera(102, "Double", 250),
    ];

    servicii = [
      Serviciu("Spa", 150),
      Serviciu("Room Service", 50),
    ];

    plati = [
      Plata(1, 450, "Card"),
      Plata(2, 500, "Cash"),
    ];

    angajati = [
      Angajat("Popa Andrei", "Recepționer"),
      Angajat("Ionescu Mihai", "Bucătar Șef"),
    ];

    evenimente = [
      Eveniment("Concert Rock", DateTime(2025, 12, 1)),
      Eveniment("Festival Jazz", DateTime(2025, 12, 5)),
    ];
  }
}
