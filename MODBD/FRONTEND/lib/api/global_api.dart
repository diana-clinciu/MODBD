import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/client.dart';

class GlobalApi extends ClientApi {
  GlobalApi() : super(baseURL: selectedApiType.baseUrl);

  // ── HOTEL GLOBAL ────────────────────────────────────────────────────────────

  Future<List<Hotel>> fetchHoteluriGlobal() => get(
        path: '/global/hoteluri',
        deserializer: (d) => (d as List).map((e) => Hotel.fromJson(e)).toList(),
      );

  Future<Hotel> addHotelGlobal(Hotel h) => sendForm(
        method: 'POST',
        path: '/global/hoteluri',
        fields: h.toFormFields(),
        deserializer: (d) => Hotel.fromJson(d),
      );

  Future<Hotel> updateHotelGlobal(Hotel h) => sendForm(
        method: 'PUT',
        path: '/global/hoteluri/${h.idHotel}',
        fields: Map.from(h.toFormFields())..remove('id_hotel'),
        deserializer: (d) => Hotel.fromJson(d),
      );

  Future<void> deleteHotelGlobal(int id) => delete(
        path: '/global/hoteluri/$id',
        deserializer: (_) {},
      );

  // ── ANGAJAT GLOBAL ──────────────────────────────────────────────────────────

  Future<List<AngajatGlobal>> fetchAngajatiGlobal() => get(
        path: '/global/angajati',
        deserializer: (d) =>
            (d as List).map((e) => AngajatGlobal.fromJson(e)).toList(),
      );

  Future<AngajatGlobal> addAngajatGlobal(AngajatGlobal a) => sendForm(
        method: 'POST',
        path: '/global/angajati',
        fields: a.toFormFields(),
        deserializer: (d) => AngajatGlobal.fromJson(d),
      );

  Future<AngajatGlobal> updateAngajatGlobal(AngajatGlobal a) => sendForm(
        method: 'PUT',
        path: '/global/angajati/${a.idAngajat}',
        fields: Map.from(a.toFormFields())..remove('id_angajat'),
        deserializer: (d) => AngajatGlobal.fromJson(d),
      );

  Future<void> deleteAngajatGlobal(int id) => delete(
        path: '/global/angajati/$id',
        deserializer: (_) {},
      );

  // ── CAMERA GLOBAL ───────────────────────────────────────────────────────────

  Future<List<CameraLocal>> fetchCamereGlobal() => get(
        path: '/global/camere',
        deserializer: (d) =>
            (d as List).map((e) => CameraLocal.fromJson(e)).toList(),
      );

  Future<CameraLocal> addCameraGlobal(CameraLocal c) => sendForm(
        method: 'POST',
        path: '/global/camere',
        fields: c.toFormFields(),
        deserializer: (d) => CameraLocal.fromJson(d),
      );

  Future<CameraLocal> updateCameraGlobal(CameraLocal c) => sendForm(
        method: 'PUT',
        path: '/global/camere/${c.idCamera}',
        fields: Map.from(c.toFormFields())..remove('id_camera'),
        deserializer: (d) => CameraLocal.fromJson(d),
      );

  Future<void> deleteCameraGlobal(int id) => delete(
        path: '/global/camere/$id',
        deserializer: (_) {},
      );

  // ── TABELE CENTRALIZATE ─────────────────────────────────────────────────────

  Future<List<Client>> fetchClientiGlobal() => get(
        path: '/global/clienti',
        deserializer: (d) =>
            (d as List).map((e) => Client.fromJson(e)).toList(),
      );

  // ── VERIFICARE PROPAGARE (Req 4) ────────────────────────────────────────────

  Future<Map<String?, dynamic>> verificareHotel(int id) => get(
        path: '/global/verificare/hoteluri/$id',
        deserializer: (d) => d as Map<String?, dynamic>,
      );

  Future<Map<String?, dynamic>> verificareAngajat(int id) => get(
        path: '/global/verificare/angajati/$id',
        deserializer: (d) => d as Map<String?, dynamic>,
      );

  Future<Map<String?, dynamic>> verificareCamera(int id) => get(
        path: '/global/verificare/camere/$id',
        deserializer: (d) => d as Map<String?, dynamic>,
      );

  // ── STATISTICI ──────────────────────────────────────────────────────────────

  Future<List<Map<String?, dynamic>>> fetchDistributie() => get(
        path: '/statistici/distributie',
        deserializer: (d) =>
            (d as List).map((e) => e as Map<String?, dynamic>).toList(),
      );
}
