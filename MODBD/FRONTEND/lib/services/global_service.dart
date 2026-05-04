import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/api/global_api.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/client.dart';

class GlobalService {
  final GlobalApi _api = GetIt.instance.get<GlobalApi>();

  Future<List<Hotel>> fetchHoteluri() => _api.fetchHoteluriGlobal();
  Future<Hotel> addHotel(Hotel h) => _api.addHotelGlobal(h);
  Future<Hotel> updateHotel(Hotel h) => _api.updateHotelGlobal(h);
  Future<void> deleteHotel(int id) => _api.deleteHotelGlobal(id);

  Future<List<AngajatGlobal>> fetchAngajati() => _api.fetchAngajatiGlobal();
  Future<AngajatGlobal> addAngajat(AngajatGlobal a) =>
      _api.addAngajatGlobal(a);
  Future<AngajatGlobal> updateAngajat(AngajatGlobal a) =>
      _api.updateAngajatGlobal(a);
  Future<void> deleteAngajat(int id) => _api.deleteAngajatGlobal(id);

  Future<List<CameraLocal>> fetchCamere() => _api.fetchCamereGlobal();
  Future<CameraLocal> addCamera(CameraLocal c) => _api.addCameraGlobal(c);
  Future<CameraLocal> updateCamera(CameraLocal c) =>
      _api.updateCameraGlobal(c);
  Future<void> deleteCamera(int id) => _api.deleteCameraGlobal(id);

  Future<List<Client>> fetchClienti() => _api.fetchClientiGlobal();

  Future<Map<String?, dynamic>> verificareHotel(int id) =>
      _api.verificareHotel(id);
  Future<Map<String?, dynamic>> verificareAngajat(int id) =>
      _api.verificareAngajat(id);
  Future<Map<String?, dynamic>> verificareCamera(int id) =>
      _api.verificareCamera(id);

  Future<List<Map<String?, dynamic>>> fetchDistributie() =>
      _api.fetchDistributie();
}
