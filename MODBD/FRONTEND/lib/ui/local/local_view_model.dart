import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/tip_camera.dart';
import 'package:mvvm_flutter/models/departament.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/serviciu.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/plata.dart';

import 'package:mvvm_flutter/services/local_service.dart';
import 'package:mvvm_flutter/services/global_service.dart';

class LocalViewModel extends ChangeNotifier {
  final LocalService _service = GetIt.instance.get<LocalService>();
  final GlobalService _globalService = GetIt.instance.get<GlobalService>();

  String? _oras = 'Bucuresti';
  String? get oras => _oras;

  bool loading = false;
  String? error;

  List<Hotel> hotels = [];
  List<AngajatGlobal> angajati = [];
  List<CameraLocal> camere = [];
  List<Client> clienti = [];
  List<Serviciu> servicii = [];
  List<TipCamera> tipuriCamera = [];
  List<Departament> departamente = [];
  List<Rezervare> rezervari = [];
  List<Plata> plati = [];

  // Global view data shown after local DML (Req 3)
  List<Hotel> globalHotels = [];
  List<AngajatGlobal> globalAngajati = [];
  List<CameraLocal> globalCamere = [];

  void setOras(String? oras) {
    _oras = oras;
    notifyListeners();
    loadAll();
  }

  Future<void> loadAll() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _service.fetchHoteluri(_oras),
        _service.fetchAngajati(_oras),
        _service.fetchCamere(_oras),
        _service.fetchTipuriCamera(_oras),
        _service.fetchDepartamente(_oras),
        _service.fetchClienti(_oras),
        _service.fetchServicii(_oras),
        _service.fetchRezervari(_oras),
        _service.fetchPlati(_oras),
      ]);
      hotels = results[0] as List<Hotel>;
      angajati = results[1] as List<AngajatGlobal>;
      camere = results[2] as List<CameraLocal>;
      tipuriCamera = results[3] as List<TipCamera>;
      departamente = results[4] as List<Departament>;
      clienti = results[5] as List<Client>;
      servicii = results[6] as List<Serviciu>;
      rezervari = results[7] as List<Rezervare>;
      plati = results[8] as List<Plata>;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  // ── HOTEL ──────────────────────────────────────────────────────────────────

  Future<void> addHotel(Hotel h) async {
    await _service.addHotel(_oras, h);
    await loadAll();
    await _refreshGlobal();
  }

  Future<void> updateHotel(Hotel h) async {
    await _service.updateHotel(_oras, h);
    await loadAll();
    await _refreshGlobal();
  }

  Future<void> deleteHotel(int id) async {
    await _service.deleteHotel(_oras, id);
    await loadAll();
    await _refreshGlobal();
  }

  // ── ANGAJAT ────────────────────────────────────────────────────────────────

  Future<void> addAngajat(AngajatGlobal a) async {
    await _service.addAngajat(_oras, a);
    await loadAll();
    await _refreshGlobal();
  }

  Future<void> updateAngajat(AngajatGlobal a) async {
    await _service.updateAngajat(_oras, a);
    await loadAll();
    await _refreshGlobal();
  }

  Future<void> deleteAngajat(int id) async {
    await _service.deleteAngajat(_oras, id);
    await loadAll();
    await _refreshGlobal();
  }

  // ── CAMERA ─────────────────────────────────────────────────────────────────

  Future<void> addCamera(CameraLocal c) async {
    await _service.addCamera(_oras, c);
    await loadAll();
    await _refreshGlobal();
  }

  Future<void> updateCamera(CameraLocal c) async {
    await _service.updateCamera(_oras, c);
    await loadAll();
    await _refreshGlobal();
  }

  Future<void> deleteCamera(int id) async {
    await _service.deleteCamera(_oras, id);
    await loadAll();
    await _refreshGlobal();
  }

  // ── CLIENT ─────────────────────────────────────────────────────────────────

  Future<void> addClient(Client c) async {
    await _service.addClient(_oras, c);
    await loadAll();
  }

  Future<void> updateClient(Client c) async {
    await _service.updateClient(_oras, c);
    await loadAll();
  }

  Future<void> deleteClient(int id) async {
    await _service.deleteClient(_oras, id);
    await loadAll();
  }

  // ── REZERVARE ──────────────────────────────────────────────────────────────

  Future<void> addRezervare(Rezervare r) async {
    await _service.addRezervare(_oras, r);
    await loadAll();
  }

  Future<void> updateRezervare(Rezervare r) async {
    await _service.updateRezervare(_oras, r);
    await loadAll();
  }

  Future<void> deleteRezervare(int id) async {
    await _service.deleteRezervare(_oras, id);
    await loadAll();
  }

  // ── PLATA ──────────────────────────────────────────────────────────────────

  Future<void> addPlata(Plata p) async {
    await _service.addPlata(_oras, p);
    await loadAll();
  }

  Future<void> updatePlata(Plata p) async {
    await _service.updatePlata(_oras, p);
    await loadAll();
  }

  Future<void> deletePlata(int id) async {
    await _service.deletePlata(_oras, id);
    await loadAll();
  }

  // ── SERVICIU ───────────────────────────────────────────────────────────────

  Future<void> addServiciu(Serviciu s) async {
    await _service.addServiciu(_oras, s);
    await loadAll();
  }

  Future<void> updateServiciu(Serviciu s) async {
    await _service.updateServiciu(_oras, s);
    await loadAll();
  }

  Future<void> deleteServiciu(int id) async {
    await _service.deleteServiciu(_oras, id);
    await loadAll();
  }

  // ── DEPARTAMENT ────────────────────────────────────────────────────────────

  Future<void> addDepartament(Departament d) async {
    await _service.addDepartament(_oras, d);
    await loadAll();
  }

  Future<void> updateDepartament(Departament d) async {
    await _service.updateDepartament(_oras, d);
    await loadAll();
  }

  Future<void> deleteDepartament(int id) async {
    await _service.deleteDepartament(_oras, id);
    await loadAll();
  }

  // ── TIP CAMERA ─────────────────────────────────────────────────────────────

  Future<void> addTipCamera(TipCamera t) async {
    await _service.addTipCamera(_oras, t);
    await loadAll();
  }

  Future<void> updateTipCamera(TipCamera t) async {
    await _service.updateTipCamera(_oras, t);
    await loadAll();
  }

  Future<void> deleteTipCamera(int id) async {
    await _service.deleteTipCamera(_oras, id);
    await loadAll();
  }

  // ── VIZUALIZARE GLOBALA (Req 3) ────────────────────────────────────────────

  Future<void> refreshGlobal() => _refreshGlobal();

  Future<void> _refreshGlobal() async {
    try {
      final h = await _globalService.fetchHoteluri();
      final a = await _globalService.fetchAngajati();
      final c = await _globalService.fetchCamere();
      globalHotels = h;
      globalAngajati = a;
      globalCamere = c;
    } catch (_) {}
    notifyListeners();
  }
}
