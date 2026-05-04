import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/api/global_api.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/plata.dart';
import 'package:mvvm_flutter/models/serviciu.dart';
import 'package:mvvm_flutter/models/departament.dart';
import 'package:mvvm_flutter/models/tip_camera.dart';


class GlobalService {
  final GlobalApi _api = GetIt.instance.get<GlobalApi>();

  Future<List<Hotel>> fetchHoteluri() => _api.fetchHoteluriGlobal();
  Future<Hotel> addHotel(Hotel h) => _api.addHotelGlobal(h);
  Future<Hotel> updateHotel(Hotel h) => _api.updateHotelGlobal(h);
  Future<void> deleteHotel(int id) => _api.deleteHotelGlobal(id);

  Future<List<AngajatGlobal>> fetchAngajati() => _api.fetchAngajatiGlobal();
  Future<AngajatGlobal> addAngajat(AngajatGlobal a) => _api.addAngajatGlobal(a);
  Future<AngajatGlobal> updateAngajat(AngajatGlobal a) => _api.updateAngajatGlobal(a);
  Future<void> deleteAngajat(int id) => _api.deleteAngajatGlobal(id);

  Future<List<CameraLocal>> fetchCamere() => _api.fetchCamereGlobal();
  Future<CameraLocal> addCamera(CameraLocal c) => _api.addCameraGlobal(c);
  Future<CameraLocal> updateCamera(CameraLocal c) => _api.updateCameraGlobal(c);
  Future<void> deleteCamera(int id) => _api.deleteCameraGlobal(id);

  Future<List<Client>> fetchClienti() => _api.fetchClientiGlobal();
  Future<Client> addClient(Client c) => _api.addClientGlobal(c);
  Future<Client> updateClient(Client c) => _api.updateClientGlobal(c);
  Future<void> deleteClient(int id) => _api.deleteClientGlobal(id);

  Future<List<Rezervare>> fetchRezervari() => _api.fetchRezervariGlobal();
  Future<Rezervare> addRezervare(Rezervare r) => _api.addRezervareGlobal(r);
  Future<Rezervare> updateRezervare(Rezervare r) => _api.updateRezervareGlobal(r);
  Future<void> deleteRezervare(int id) => _api.deleteRezervareGlobal(id);

  Future<List<Plata>> fetchPlati() => _api.fetchPlatiGlobal();
  Future<Plata> addPlata(Plata p) => _api.addPlataGlobal(p);
  Future<Plata> updatePlata(Plata p) => _api.updatePlataGlobal(p);
  Future<void> deletePlata(int id) => _api.deletePlataGlobal(id);

  Future<List<Serviciu>> fetchServicii() => _api.fetchServiciiGlobal();
  Future<Serviciu> addServiciu(Serviciu s) => _api.addServiciuGlobal(s);
  Future<Serviciu> updateServiciu(Serviciu s) => _api.updateServiciuGlobal(s);
  Future<void> deleteServiciu(int id) => _api.deleteServiciuGlobal(id);

  Future<List<Departament>> fetchDepartamente() => _api.fetchDepartamenteGlobal();
  Future<Departament> addDepartament(Departament d) => _api.addDepartamentGlobal(d);
  Future<Departament> updateDepartament(Departament d) => _api.updateDepartamentGlobal(d);
  Future<void> deleteDepartament(int id) => _api.deleteDepartamentGlobal(id);

  Future<List<TipCamera>> fetchTipuriCamera() => _api.fetchTipuriCameraGlobal();
  Future<TipCamera> addTipCamera(TipCamera t) => _api.addTipCameraGlobal(t);
  Future<TipCamera> updateTipCamera(TipCamera t) => _api.updateTipCameraGlobal(t);
  Future<void> deleteTipCamera(int id) => _api.deleteTipCameraGlobal(id);

  Future<Map<String?, dynamic>> verificareHotel(int id) => _api.verificareHotel(id);
  Future<Map<String?, dynamic>> verificareAngajat(int id) => _api.verificareAngajat(id);
  Future<Map<String?, dynamic>> verificareCamera(int id) => _api.verificareCamera(id);

  Future<List<Map<String?, dynamic>>> fetchDistributie() => _api.fetchDistributie();
}
