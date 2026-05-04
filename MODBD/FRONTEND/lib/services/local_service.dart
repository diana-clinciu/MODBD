import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/api/local_api.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/tip_camera.dart';
import 'package:mvvm_flutter/models/departament.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/serviciu.dart';

class LocalService {
  final LocalApi _api = GetIt.instance.get<LocalApi>();

  Future<List<Hotel>> fetchHoteluri(String? oras) =>
      _api.fetchHoteluriLocal(oras);
  Future<Hotel> addHotel(String? oras, Hotel h) =>
      _api.addHotelLocal(oras, h);
  Future<Hotel> updateHotel(String? oras, Hotel h) =>
      _api.updateHotelLocal(oras, h);
  Future<void> deleteHotel(String? oras, int id) =>
      _api.deleteHotelLocal(oras, id);

  Future<List<AngajatGlobal>> fetchAngajati(String? oras) =>
      _api.fetchAngajatiLocal(oras);
  Future<AngajatGlobal> addAngajat(String? oras, AngajatGlobal a) =>
      _api.addAngajatGlobal(oras, a);
  Future<AngajatGlobal> updateAngajat(String? oras, AngajatGlobal a) =>
      _api.updateAngajatGlobal(oras, a);
  Future<void> deleteAngajat(String? oras, int id) =>
      _api.deleteAngajatGlobal(oras, id);

  Future<List<CameraLocal>> fetchCamere(String? oras) =>
      _api.fetchCamereLocal(oras);
  Future<CameraLocal> addCamera(String? oras, CameraLocal c) =>
      _api.addCameraLocal(oras, c);
  Future<CameraLocal> updateCamera(String? oras, CameraLocal c) =>
      _api.updateCameraLocal(oras, c);
  Future<void> deleteCamera(String? oras, int id) =>
      _api.deleteCameraLocal(oras, id);

  Future<List<Client>> fetchClienti(String? oras) =>
      _api.fetchClientiLocal(oras);
  Future<List<Serviciu>> fetchServicii(String? oras) =>
      _api.fetchServiciiLocal(oras);

  Future<List<TipCamera>> fetchTipuriCamera(String? oras) =>
      _api.fetchTipuriCamera(oras);
  Future<List<Departament>> fetchDepartamente(String? oras) =>
      _api.fetchDepartamente(oras);
}
