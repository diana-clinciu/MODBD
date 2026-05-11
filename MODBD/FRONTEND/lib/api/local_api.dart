import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/tip_camera.dart';
import 'package:mvvm_flutter/models/departament.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/serviciu.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/plata.dart';

class LocalApi extends ClientApi {
  LocalApi() : super(baseURL: selectedApiType.baseUrl);

  String? _p(String? oras) => oras == 'Bucuresti' ? '/local/buc' : '/local/con';

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

  Future<Client> addClientLocal(String? oras, Client c) => sendForm(
        method: 'POST',
        path: '${_p(oras)}/clienti',
        fields: c.toFormFields(),
        deserializer: (d) => Client.fromJson(d),
      );

  Future<Client> updateClientLocal(String? oras, Client c) => sendForm(
        method: 'PUT',
        path: '${_p(oras)}/clienti/${c.id}',
        fields: Map.from(c.toFormFields())..remove('id_client'),
        deserializer: (d) => Client.fromJson(d),
      );

  Future<void> deleteClientLocal(String? oras, int id) => delete(
        path: '${_p(oras)}/clienti/$id',
        deserializer: (_) {},
      );

  Future<List<Rezervare>> fetchRezervariLocal(String? oras) => get(
        path: '${_p(oras)}/rezervari',
        deserializer: (d) =>
            (d as List).map((e) => Rezervare.fromJson(e)).toList(),
      );

  Future<Rezervare> addRezervareLocal(String? oras, Rezervare r) => sendForm(
        method: 'POST',
        path: '${_p(oras)}/rezervari',
        fields: r.toFormFields(),
        deserializer: (d) => Rezervare.fromJson(d),
      );

  Future<Rezervare> updateRezervareLocal(String? oras, Rezervare r) => sendForm(
        method: 'PUT',
        path: '${_p(oras)}/rezervari/${r.id}',
        fields: Map.from(r.toFormFields())..remove('id_rezervare'),
        deserializer: (d) => Rezervare.fromJson(d),
      );

  Future<void> deleteRezervareLocal(String? oras, int id) => delete(
        path: '${_p(oras)}/rezervari/$id',
        deserializer: (_) {},
      );

  Future<List<Plata>> fetchPlatiLocal(String? oras) => get(
        path: '${_p(oras)}/plati',
        deserializer: (d) => (d as List).map((e) => Plata.fromJson(e)).toList(),
      );

  Future<Plata> addPlataLocal(String? oras, Plata p) => sendForm(
        method: 'POST',
        path: '${_p(oras)}/plati',
        fields: p.toFormFields(),
        deserializer: (d) => Plata.fromJson(d),
      );

  Future<Plata> updatePlataLocal(String? oras, Plata p) => sendForm(
        method: 'PUT',
        path: '${_p(oras)}/plati/${p.id}',
        fields: Map.from(p.toFormFields())..remove('id_plata'),
        deserializer: (d) => Plata.fromJson(d),
      );

  Future<void> deletePlataLocal(String? oras, int id) => delete(
        path: '${_p(oras)}/plati/$id',
        deserializer: (_) {},
      );

  Future<Serviciu> addServiciuLocal(String? oras, Serviciu s) => sendForm(
        method: 'POST',
        path: '${_p(oras)}/servicii',
        fields: s.toFormFields(),
        deserializer: (d) => Serviciu.fromJson(d),
      );

  Future<Serviciu> updateServiciuLocal(String? oras, Serviciu s) => sendForm(
        method: 'PUT',
        path: '${_p(oras)}/servicii/${s.idServiciu}',
        fields: Map.from(s.toFormFields())..remove('id_serviciu'),
        deserializer: (d) => Serviciu.fromJson(d),
      );

  Future<void> deleteServiciuLocal(String? oras, int id) => delete(
        path: '${_p(oras)}/servicii/$id',
        deserializer: (_) {},
      );

  Future<List<Departament>> fetchDepartamenteLocal(String? oras) => get(
        path: '${_p(oras)}/departamente',
        deserializer: (d) =>
            (d as List).map((e) => Departament.fromJson(e)).toList(),
      );

  Future<Departament> addDepartamentLocal(String? oras, Departament d) => sendForm(
        method: 'POST',
        path: '${_p(oras)}/departamente',
        fields: d.toFormFields(),
        deserializer: (dd) => Departament.fromJson(dd),
      );

  Future<Departament> updateDepartamentLocal(String? oras, Departament d) => sendForm(
        method: 'PUT',
        path: '${_p(oras)}/departamente/${d.idDepartament}',
        fields: Map.from(d.toFormFields())..remove('id_departament'),
        deserializer: (dd) => Departament.fromJson(dd),
      );

  Future<void> deleteDepartamentLocal(String? oras, int id) => delete(
        path: '${_p(oras)}/departamente/$id',
        deserializer: (_) {},
      );

  Future<List<TipCamera>> fetchTipuriCameraLocal(String? oras) => get(
        path: '${_p(oras)}/tipuri_camera',
        deserializer: (d) =>
            (d as List).map((e) => TipCamera.fromJson(e)).toList(),
      );

  Future<TipCamera> addTipCameraLocal(String? oras, TipCamera t) => sendForm(
        method: 'POST',
        path: '${_p(oras)}/tipuri_camera',
        fields: t.toFormFields(),
        deserializer: (d) => TipCamera.fromJson(d),
      );

  Future<TipCamera> updateTipCameraLocal(String? oras, TipCamera t) => sendForm(
        method: 'PUT',
        path: '${_p(oras)}/tipuri_camera/${t.idTipCamera}',
        fields: Map.from(t.toFormFields())..remove('id_tip_camera'),
        deserializer: (d) => TipCamera.fromJson(d),
      );

  Future<void> deleteTipCameraLocal(String? oras, int id) => delete(
        path: '${_p(oras)}/tipuri_camera/$id',
        deserializer: (_) {},
      );

}
