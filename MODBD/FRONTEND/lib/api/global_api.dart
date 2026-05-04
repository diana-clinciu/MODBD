import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/plata.dart';
import 'package:mvvm_flutter/models/serviciu.dart';
import 'package:mvvm_flutter/models/departament.dart';
import 'package:mvvm_flutter/models/tip_camera.dart';


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

  // ── CLIENT GLOBAL ────────────────────────────────────────────────────────────

  Future<List<Client>> fetchClientiGlobal() => get(
        path: '/global/clienti',
        deserializer: (d) =>
            (d as List).map((e) => Client.fromJson(e)).toList(),
      );

  Future<Client> addClientGlobal(Client c) => sendForm(
        method: 'POST',
        path: '/global/clienti',
        fields: c.toFormFields(),
        deserializer: (d) => Client.fromJson(d),
      );

  Future<Client> updateClientGlobal(Client c) => sendForm(
        method: 'PUT',
        path: '/global/clienti/${c.id}',
        fields: Map.from(c.toFormFields())..remove('id_client'),
        deserializer: (d) => Client.fromJson(d),
      );

  Future<void> deleteClientGlobal(int id) => delete(
        path: '/global/clienti/$id',
        deserializer: (_) {},
      );

  // ── REZERVARE GLOBAL ─────────────────────────────────────────────────────────

  Future<List<Rezervare>> fetchRezervariGlobal() => get(
        path: '/global/rezervari',
        deserializer: (d) =>
            (d as List).map((e) => Rezervare.fromJson(e)).toList(),
      );

  Future<Rezervare> addRezervareGlobal(Rezervare r) => sendForm(
        method: 'POST',
        path: '/global/rezervari',
        fields: r.toFormFields(),
        deserializer: (d) => Rezervare.fromJson(d),
      );

  Future<Rezervare> updateRezervareGlobal(Rezervare r) => sendForm(
        method: 'PUT',
        path: '/global/rezervari/${r.id}',
        fields: Map.from(r.toFormFields())..remove('id_rezervare'),
        deserializer: (d) => Rezervare.fromJson(d),
      );

  Future<void> deleteRezervareGlobal(int id) => delete(
        path: '/global/rezervari/$id',
        deserializer: (_) {},
      );

  // ── PLATA GLOBAL ─────────────────────────────────────────────────────────────

  Future<List<Plata>> fetchPlatiGlobal() => get(
        path: '/global/plati',
        deserializer: (d) => (d as List).map((e) => Plata.fromJson(e)).toList(),
      );

  Future<Plata> addPlataGlobal(Plata p) => sendForm(
        method: 'POST',
        path: '/global/plati',
        fields: p.toFormFields(),
        deserializer: (d) => Plata.fromJson(d),
      );

  Future<Plata> updatePlataGlobal(Plata p) => sendForm(
        method: 'PUT',
        path: '/global/plati/${p.id}',
        fields: Map.from(p.toFormFields())..remove('id_plata'),
        deserializer: (d) => Plata.fromJson(d),
      );

  Future<void> deletePlataGlobal(int id) => delete(
        path: '/global/plati/$id',
        deserializer: (_) {},
      );

  // ── SERVICIU GLOBAL ───────────────────────────────────────────────────────────

  Future<List<Serviciu>> fetchServiciiGlobal() => get(
        path: '/global/servicii',
        deserializer: (d) =>
            (d as List).map((e) => Serviciu.fromJson(e)).toList(),
      );

  Future<Serviciu> addServiciuGlobal(Serviciu s) => sendForm(
        method: 'POST',
        path: '/global/servicii',
        fields: s.toFormFields(),
        deserializer: (d) => Serviciu.fromJson(d),
      );

  Future<Serviciu> updateServiciuGlobal(Serviciu s) => sendForm(
        method: 'PUT',
        path: '/global/servicii/${s.idServiciu}',
        fields: Map.from(s.toFormFields())..remove('id_serviciu'),
        deserializer: (d) => Serviciu.fromJson(d),
      );

  Future<void> deleteServiciuGlobal(int id) => delete(
        path: '/global/servicii/$id',
        deserializer: (_) {},
      );

  // ── DEPARTAMENT GLOBAL ────────────────────────────────────────────────────────

  Future<List<Departament>> fetchDepartamenteGlobal() => get(
        path: '/global/departamente',
        deserializer: (d) =>
            (d as List).map((e) => Departament.fromJson(e)).toList(),
      );

  Future<Departament> addDepartamentGlobal(Departament d) => sendForm(
        method: 'POST',
        path: '/global/departamente',
        fields: d.toFormFields(),
        deserializer: (dd) => Departament.fromJson(dd),
      );

  Future<Departament> updateDepartamentGlobal(Departament d) => sendForm(
        method: 'PUT',
        path: '/global/departamente/${d.idDepartament}',
        fields: Map.from(d.toFormFields())..remove('id_departament'),
        deserializer: (dd) => Departament.fromJson(dd),
      );

  Future<void> deleteDepartamentGlobal(int id) => delete(
        path: '/global/departamente/$id',
        deserializer: (_) {},
      );

  // ── TIP CAMERA GLOBAL ─────────────────────────────────────────────────────────

  Future<List<TipCamera>> fetchTipuriCameraGlobal() => get(
        path: '/global/tipuri_camera',
        deserializer: (d) =>
            (d as List).map((e) => TipCamera.fromJson(e)).toList(),
      );

  Future<TipCamera> addTipCameraGlobal(TipCamera t) => sendForm(
        method: 'POST',
        path: '/global/tipuri_camera',
        fields: t.toFormFields(),
        deserializer: (d) => TipCamera.fromJson(d),
      );

  Future<TipCamera> updateTipCameraGlobal(TipCamera t) => sendForm(
        method: 'PUT',
        path: '/global/tipuri_camera/${t.idTipCamera}',
        fields: Map.from(t.toFormFields())..remove('id_tip_camera'),
        deserializer: (d) => TipCamera.fromJson(d),
      );

  Future<void> deleteTipCameraGlobal(int id) => delete(
        path: '/global/tipuri_camera/$id',
        deserializer: (_) {},
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
