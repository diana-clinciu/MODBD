import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/services/global_service.dart';

class GlobalViewModel extends ChangeNotifier {
  final GlobalService _service = GetIt.instance.get<GlobalService>();

  bool loading = false;
  String? error;

  List<Hotel> hotels = [];
  List<AngajatGlobal> angajati = [];
  List<CameraLocal> camere = [];
  List<Client> clienti = [];

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
      ]);
      hotels = results[0] as List<Hotel>;
      angajati = results[1] as List<AngajatGlobal>;
      camere = results[2] as List<CameraLocal>;
      clienti = results[3] as List<Client>;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  // ── HOTEL ──────────────────────────────────────────────────────────────────

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

  // ── ANGAJAT ────────────────────────────────────────────────────────────────

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

  // ── CAMERA ─────────────────────────────────────────────────────────────────

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

  // ── VERIFICARE PROPAGARE (Req 4) ───────────────────────────────────────────

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
