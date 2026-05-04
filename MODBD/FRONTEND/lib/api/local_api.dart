import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/tip_camera.dart';
import 'package:mvvm_flutter/models/departament.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/serviciu.dart';

class LocalApi extends ClientApi {
  LocalApi() : super(baseURL: selectedApiType.baseUrl);

  String? _p(String? oras) => oras == 'Bucuresti' ? '/local/buc' : '/local/con';

  // ── HOTEL ──────────────────────────────────────────────────────────────────

  Future<List<Hotel>> fetchHoteluriLocal(String? oras) => get(
        path: '${_p(oras)}/hoteluri',
        deserializer: (d) => (d as List).map((e) => Hotel.fromJson(e)).toList(),
      );

  Future<Hotel> addHotelLocal(String? oras, Hotel h) => sendForm(
        method: 'POST',
        path: '${_p(oras)}/hoteluri',
        fields: h.toFormFields(),
        deserializer: (d) => Hotel.fromJson(d),
      );

  Future<Hotel> updateHotelLocal(String? oras, Hotel h) => sendForm(
        method: 'PUT',
        path: '${_p(oras)}/hoteluri/${h.idHotel}',
        fields: Map.from(h.toFormFields())..remove('id_hotel'),
        deserializer: (d) => Hotel.fromJson(d),
      );

  Future<void> deleteHotelLocal(String? oras, int id) => delete(
        path: '${_p(oras)}/hoteluri/$id',
        deserializer: (_) {},
      );

  // ── ANGAJAT ────────────────────────────────────────────────────────────────

  Future<List<AngajatGlobal>> fetchAngajatiLocal(String? oras) => get(
        path: '${_p(oras)}/angajati',
        deserializer: (d) =>
            (d as List).map((e) => AngajatGlobal.fromJson(e)).toList(),
      );

  Future<AngajatGlobal> addAngajatGlobal(String? oras, AngajatGlobal a) => sendForm(
        method: 'POST',
        path: '${_p(oras)}/angajati',
        fields: a.toFormFields(),
        deserializer: (d) => AngajatGlobal.fromJson(d),
      );

  Future<AngajatGlobal> updateAngajatGlobal(String? oras, AngajatGlobal a) =>
      sendForm(
        method: 'PUT',
        path: '${_p(oras)}/angajati/${a.idAngajat}',
        fields: Map.from(a.toFormFields())..remove('id_angajat'),
        deserializer: (d) => AngajatGlobal.fromJson(d),
      );

  Future<void> deleteAngajatGlobal(String? oras, int id) => delete(
        path: '${_p(oras)}/angajati/$id',
        deserializer: (_) {},
      );

  // ── CAMERA ─────────────────────────────────────────────────────────────────

  Future<List<CameraLocal>> fetchCamereLocal(String? oras) => get(
        path: '${_p(oras)}/camere',
        deserializer: (d) =>
            (d as List).map((e) => CameraLocal.fromJson(e)).toList(),
      );

  Future<CameraLocal> addCameraLocal(String? oras, CameraLocal c) => sendForm(
        method: 'POST',
        path: '${_p(oras)}/camere',
        fields: c.toFormFields(),
        deserializer: (d) => CameraLocal.fromJson(d),
      );

  Future<CameraLocal> updateCameraLocal(String? oras, CameraLocal c) => sendForm(
        method: 'PUT',
        path: '${_p(oras)}/camere/${c.idCamera}',
        fields: Map.from(c.toFormFields())..remove('id_camera'),
        deserializer: (d) => CameraLocal.fromJson(d),
      );

  Future<void> deleteCameraLocal(String? oras, int id) => delete(
        path: '${_p(oras)}/camere/$id',
        deserializer: (_) {},
      );

  // ── REPLICI CONSTANTA ──────────────────────────────────────────────────────

  Future<List<Client>> fetchClientiLocal(String? oras) => get(
        path: '${_p(oras)}/clienti',
        deserializer: (d) =>
            (d as List).map((e) => Client.fromJson(e)).toList(),
      );

  Future<List<Serviciu>> fetchServiciiLocal(String? oras) => get(
        path: '${_p(oras)}/servicii',
        deserializer: (d) =>
            (d as List).map((e) => Serviciu.fromJson(e)).toList(),
      );

  // ── REFERINTA ──────────────────────────────────────────────────────────────

  Future<List<TipCamera>> fetchTipuriCamera(String? oras) => get(
        path: '${_p(oras)}/referinta/tipuri_camera',
        deserializer: (d) =>
            (d as List).map((e) => TipCamera.fromJson(e)).toList(),
      );

  Future<List<Departament>> fetchDepartamente(String? oras) => get(
        path: '${_p(oras)}/referinta/departamente',
        deserializer: (d) =>
            (d as List).map((e) => Departament.fromJson(e)).toList(),
      );
}
