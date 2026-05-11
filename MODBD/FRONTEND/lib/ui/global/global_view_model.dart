import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/plata.dart';
import 'package:mvvm_flutter/models/serviciu.dart';
import 'package:mvvm_flutter/models/departament.dart';
import 'package:mvvm_flutter/models/tip_camera.dart';

import 'package:mvvm_flutter/services/global_service.dart';

class GlobalViewModel extends ChangeNotifier {
  final GlobalService _service = GetIt.instance.get<GlobalService>();

  bool loading = false;
  String? error;

  List<Hotel> hotels = [];
  List<AngajatGlobal> angajati = [];
  List<CameraLocal> camere = [];
  List<Client> clienti = [];
  List<Rezervare> rezervari = [];
  List<Plata> plati = [];
  List<Serviciu> servicii = [];
  List<Departament> departamente = [];
  List<TipCamera> tipuriCamera = [];

  Map<String?, dynamic>? lastVerificare;
  bool verificareLoading = false;

  Future<void> loadAll() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _service.fetchHoteluri(),
        _service.fetchAngajati(),
        _service.fetchCamere(),
        _service.fetchClienti(),
        _service.fetchRezervari(),
        _service.fetchPlati(),
        _service.fetchServicii(),
        _service.fetchDepartamente(),
        _service.fetchTipuriCamera(),
      ]);
      hotels = results[0] as List<Hotel>;
      angajati = results[1] as List<AngajatGlobal>;
      camere = results[2] as List<CameraLocal>;
      clienti = results[3] as List<Client>;
      rezervari = results[4] as List<Rezervare>;
      plati = results[5] as List<Plata>;
      servicii = results[6] as List<Serviciu>;
      departamente = results[7] as List<Departament>;
      tipuriCamera = results[8] as List<TipCamera>;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> addHotel(Hotel h) async {
    await _service.addHotel(h);
    await loadAll();
  }

  Future<void> updateHotel(Hotel h) async {
    await _service.updateHotel(h);
    await loadAll();
  }

  Future<void> deleteHotel(int id) async {
    await _service.deleteHotel(id);
    await loadAll();
  }

  Future<void> addAngajat(AngajatGlobal a) async {
    await _service.addAngajat(a);
    await loadAll();
  }

  Future<void> updateAngajat(AngajatGlobal a) async {
    await _service.updateAngajat(a);
    await loadAll();
  }

  Future<void> deleteAngajat(int id) async {
    await _service.deleteAngajat(id);
    await loadAll();
  }

  Future<void> addCamera(CameraLocal c) async {
    await _service.addCamera(c);
    await loadAll();
  }

  Future<void> updateCamera(CameraLocal c) async {
    await _service.updateCamera(c);
    await loadAll();
  }

  Future<void> deleteCamera(int id) async {
    await _service.deleteCamera(id);
    await loadAll();
  }

  Future<void> addClient(Client c) async {
    await _service.addClient(c);
    await loadAll();
  }

  Future<void> updateClient(Client c) async {
    await _service.updateClient(c);
    await loadAll();
  }

  Future<void> deleteClient(int id) async {
    await _service.deleteClient(id);
    await loadAll();
  }

  Future<void> addRezervare(Rezervare r) async {
    await _service.addRezervare(r);
    await loadAll();
  }

  Future<void> updateRezervare(Rezervare r) async {
    await _service.updateRezervare(r);
    await loadAll();
  }

  Future<void> deleteRezervare(int id) async {
    await _service.deleteRezervare(id);
    await loadAll();
  }

  Future<void> addPlata(Plata p) async {
    await _service.addPlata(p);
    await loadAll();
  }

  Future<void> updatePlata(Plata p) async {
    await _service.updatePlata(p);
    await loadAll();
  }

  Future<void> deletePlata(int id) async {
    await _service.deletePlata(id);
    await loadAll();
  }

  Future<void> addServiciu(Serviciu s) async {
    await _service.addServiciu(s);
    await loadAll();
  }

  Future<void> updateServiciu(Serviciu s) async {
    await _service.updateServiciu(s);
    await loadAll();
  }

  Future<void> deleteServiciu(int id) async {
    await _service.deleteServiciu(id);
    await loadAll();
  }

  Future<void> addDepartament(Departament d) async {
    await _service.addDepartament(d);
    await loadAll();
  }

  Future<void> updateDepartament(Departament d) async {
    await _service.updateDepartament(d);
    await loadAll();
  }

  Future<void> deleteDepartament(int id) async {
    await _service.deleteDepartament(id);
    await loadAll();
  }

  Future<void> addTipCamera(TipCamera t) async {
    await _service.addTipCamera(t);
    await loadAll();
  }

  Future<void> updateTipCamera(TipCamera t) async {
    await _service.updateTipCamera(t);
    await loadAll();
  }

  Future<void> deleteTipCamera(int id) async {
    await _service.deleteTipCamera(id);
    await loadAll();
  }

  Future<void> verificaHotel(int id) async {
    verificareLoading = true;
    notifyListeners();
    try {
      lastVerificare = await _service.verificareHotel(id);
    } catch (e) {
      lastVerificare = {'error': e.toString()};
    }
    verificareLoading = false;
    notifyListeners();
  }

  Future<void> verificaAngajat(int id) async {
    verificareLoading = true;
    notifyListeners();
    try {
      lastVerificare = await _service.verificareAngajat(id);
    } catch (e) {
      lastVerificare = {'error': e.toString()};
    }
    verificareLoading = false;
    notifyListeners();
  }

  Future<void> verificaCamera(int id) async {
    verificareLoading = true;
    notifyListeners();
    try {
      lastVerificare = await _service.verificareCamera(id);
    } catch (e) {
      lastVerificare = {'error': e.toString()};
    }
    verificareLoading = false;
    notifyListeners();
  }
}
