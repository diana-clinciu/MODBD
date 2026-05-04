import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/api/local_api.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/tip_camera.dart';
import 'package:mvvm_flutter/models/departament.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/serviciu.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/plata.dart';


class LocalService {
  final LocalApi _api = GetIt.instance.get<LocalApi>();

  Future<List<Hotel>> fetchHoteluri(String? oras) => _api.fetchHoteluriLocal(oras);
  Future<Hotel> addHotel(String? oras, Hotel h) => _api.addHotelLocal(oras, h);
  Future<Hotel> updateHotel(String? oras, Hotel h) => _api.updateHotelLocal(oras, h);
  Future<void> deleteHotel(String? oras, int id) => _api.deleteHotelLocal(oras, id);

  Future<List<AngajatGlobal>> fetchAngajati(String? oras) => _api.fetchAngajatiLocal(oras);
  Future<AngajatGlobal> addAngajat(String? oras, AngajatGlobal a) => _api.addAngajatGlobal(oras, a);
  Future<AngajatGlobal> updateAngajat(String? oras, AngajatGlobal a) => _api.updateAngajatGlobal(oras, a);
  Future<void> deleteAngajat(String? oras, int id) => _api.deleteAngajatGlobal(oras, id);

  Future<List<CameraLocal>> fetchCamere(String? oras) => _api.fetchCamereLocal(oras);
  Future<CameraLocal> addCamera(String? oras, CameraLocal c) => _api.addCameraLocal(oras, c);
  Future<CameraLocal> updateCamera(String? oras, CameraLocal c) => _api.updateCameraLocal(oras, c);
  Future<void> deleteCamera(String? oras, int id) => _api.deleteCameraLocal(oras, id);

  Future<List<Client>> fetchClienti(String? oras) => _api.fetchClientiLocal(oras);
  Future<Client> addClient(String? oras, Client c) => _api.addClientLocal(oras, c);
  Future<Client> updateClient(String? oras, Client c) => _api.updateClientLocal(oras, c);
  Future<void> deleteClient(String? oras, int id) => _api.deleteClientLocal(oras, id);

  Future<List<Rezervare>> fetchRezervari(String? oras) => _api.fetchRezervariLocal(oras);
  Future<Rezervare> addRezervare(String? oras, Rezervare r) => _api.addRezervareLocal(oras, r);
  Future<Rezervare> updateRezervare(String? oras, Rezervare r) => _api.updateRezervareLocal(oras, r);
  Future<void> deleteRezervare(String? oras, int id) => _api.deleteRezervareLocal(oras, id);

  Future<List<Plata>> fetchPlati(String? oras) => _api.fetchPlatiLocal(oras);
  Future<Plata> addPlata(String? oras, Plata p) => _api.addPlataLocal(oras, p);
  Future<Plata> updatePlata(String? oras, Plata p) => _api.updatePlataLocal(oras, p);
  Future<void> deletePlata(String? oras, int id) => _api.deletePlataLocal(oras, id);

  Future<List<Serviciu>> fetchServicii(String? oras) => _api.fetchServiciiLocal(oras);
  Future<Serviciu> addServiciu(String? oras, Serviciu s) => _api.addServiciuLocal(oras, s);
  Future<Serviciu> updateServiciu(String? oras, Serviciu s) => _api.updateServiciuLocal(oras, s);
  Future<void> deleteServiciu(String? oras, int id) => _api.deleteServiciuLocal(oras, id);

  Future<List<Departament>> fetchDepartamente(String? oras) => _api.fetchDepartamente(oras);
  Future<List<Departament>> fetchDepartamenteLocal(String? oras) => _api.fetchDepartamenteLocal(oras);
  Future<Departament> addDepartament(String? oras, Departament d) => _api.addDepartamentLocal(oras, d);
  Future<Departament> updateDepartament(String? oras, Departament d) => _api.updateDepartamentLocal(oras, d);
  Future<void> deleteDepartament(String? oras, int id) => _api.deleteDepartamentLocal(oras, id);

  Future<List<TipCamera>> fetchTipuriCamera(String? oras) => _api.fetchTipuriCamera(oras);
  Future<List<TipCamera>> fetchTipuriCameraLocal(String? oras) => _api.fetchTipuriCameraLocal(oras);
  Future<TipCamera> addTipCamera(String? oras, TipCamera t) => _api.addTipCameraLocal(oras, t);
  Future<TipCamera> updateTipCamera(String? oras, TipCamera t) => _api.updateTipCameraLocal(oras, t);
  Future<void> deleteTipCamera(String? oras, int id) => _api.deleteTipCameraLocal(oras, id);

}
