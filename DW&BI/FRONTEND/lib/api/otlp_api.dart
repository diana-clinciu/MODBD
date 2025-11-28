import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';
import 'package:mvvm_flutter/models/angajat.dart';
import 'package:mvvm_flutter/models/camera.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/eveniment.dart';
import 'package:mvvm_flutter/models/plata.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/serviciu.dart';

final class OtlpApi extends ClientApi {
  OtlpApi() : super(baseURL: selectedApiType.baseUrl);

  Future<List<Client>> fetchClients() async {
    return get(
      path: "clients",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((clientJson) => Client.fromJson(clientJson))
            .toList();
      },
    );
  }

  Future<Client> addClient(Client client) async {
    try {
      return await multiPartRequest(
        path: "clients/add",
        multipartEncoding: (form) {
          form.append(client.nume, withName: "nume");
          form.append(client.email, withName: "email");
          form.append(client.prenume, withName: "prenume");
        },
        deserializer: (json) => Client.fromJson(json),
      );
    } on ApiException catch (e) {
      print('Error adding client: ${e.errorBody}');
      rethrow;
    }
  }

  Future<Client> updateClient(Client client) async {
    try {
      return await multiPartRequest(
        path: "clients/${client.id}",
        multipartEncoding: (form) {
          form.append(client.nume, withName: "nume");
          form.append(client.email, withName: "email");
          form.append(client.prenume, withName: "prenume");
        },
        deserializer: (json) => Client.fromJson(json),
      );
    } on ApiException catch (e) {
      print('Error updating client: ${e.errorBody}');
      rethrow;
    }
  }

  Future<void> deleteClient(int id_client) async {
    return post(path: "clients/delete/$id_client", deserializer: (json) {});
  }

  Future<List<Rezervare>> fetchRezervari() async {
    return get(
        path: "rezervari",
        deserializer: (json) {
          return (json as List<dynamic>)
              .map((clientJson) => Rezervare.fromJson(clientJson))
              .toList();
        });
  }

  Future<Rezervare> addRezervare(Rezervare rezervare) async {
    try {
      return await multiPartRequest(
        path: "rezervari",
        multipartEncoding: (form) {
          form.append(rezervare.clientId.toString(), withName: "id_client");
          form.append(rezervare.data.toIso8601String(), withName: "data");
        },
        deserializer: (json) {
          return Rezervare.fromJson(json);
        },
      );
    } on ApiException catch (e) {
      print('Error adding rezervare: ${e.errorBody}');
      rethrow;
    }
  }

  Future<Rezervare> updateRezervare(Rezervare rezervare) async {
    try {
      return await multiPartRequest(
        path: "rezervari/update/${rezervare.id}",
        multipartEncoding: (form) {
          form.append(rezervare.clientId.toString(), withName: "id_client");
          form.append(rezervare.data.toIso8601String(), withName: "data");
        },
        deserializer: (json) {
          return Rezervare.fromJson(json);
        },
      );
    } on ApiException catch (e) {
      print('Error updating rezervare: ${e.errorBody}');
      rethrow;
    }
  }

  Future<void> deleteRezervare(int id) async {
    return post(path: "rezervari/delete/$id", deserializer: (json) {});
  }

  Future<List<Camera>> fetchCamere() async {
    return get(
        path: "camere",
        deserializer: (json) {
          return (json as List<dynamic>)
              .map((clientJson) => Camera.fromJson(clientJson))
              .toList();
        });
  }

  Future<Camera> addCamera(Camera camera) async {
    try {
      return await multiPartRequest(
          path: "camere/add",
          multipartEncoding: (form) {
            form.append(camera.nr.toString(), withName: "nr_camera");
            form.append(camera.tip, withName: "tip_camera");
            form.append(camera.pret.toString(), withName: "pret");
          },
          deserializer: (json) {
            return Camera.fromJson(json);
          });
    } on ApiException catch (e) {
      print('Error adding camera: ${e.errorBody}');
      rethrow;
    }
  }

  Future<Camera> updateCamera(Camera camera) async {
    try {
      return await multiPartRequest(
          path: "camere/${camera.id}",
          multipartEncoding: (form) {
            form.append(camera.nr.toString(), withName: "nr_camera");
            form.append(camera.tip, withName: "tip_camera");
            form.append(camera.pret.toString(), withName: "pret");
          },
          deserializer: (json) {
            return Camera.fromJson(json);
          });
    } on ApiException catch (e) {
      print('Error updating camera: ${e.errorBody}');
      rethrow;
    }
  }

  Future<void> deleteCamera(int id) async {
    return post(path: "camere/delete/$id", deserializer: (json) {});
  }

  Future<List<Serviciu>> fetchServicii() async {
    return get(
        path: "servicii",
        deserializer: (json) {
          return (json as List<dynamic>)
              .map((clientJson) => Serviciu.fromJson(clientJson))
              .toList();
        });
  }

  Future<Serviciu> addServiciu(Serviciu serviciu) async {
    try {
      return await multiPartRequest(
          path: "servicii/add",
          multipartEncoding: (form) {
            form.append(serviciu.denumire, withName: "denumire");
            form.append(serviciu.pret.toString(), withName: "pret");
          },
          deserializer: (json) {
            return Serviciu.fromJson(json);
          });
    } on ApiException catch (e) {
      print('Error adding serviciu: ${e.errorBody}');
      rethrow;
    }
  }

  Future<Serviciu> updateServiciu(Serviciu serviciu) async {
    try {
      return await multiPartRequest(
          path: "servicii/${serviciu.id}",
          multipartEncoding: (form) {
            form.append(serviciu.denumire, withName: "denumire");
            form.append(serviciu.pret.toString(), withName: "pret");
          },
          deserializer: (json) {
            return Serviciu.fromJson(json);
          });
    } on ApiException catch (e) {
      print('Error updating serviciu: ${e.errorBody}');
      rethrow;
    }
  }

  Future<void> deleteServiciu(int id) async {
    return post(path: "servicii/delete/$id", deserializer: (json) {});
  }

  Future<List<Plata>> fetchPlati() async {
    return get(
        path: "plati",
        deserializer: (json) {
          return (json["data"] as List<dynamic>)
              .map((clientJson) => Plata.fromJson(clientJson))
              .toList();
        });
  }

  Future<Plata> addPlata(Plata plata) async {
    try {
      return await multiPartRequest(
          path: "plati/add",
          multipartEncoding: (form) {
            form.append(plata.metoda, withName: "metoda");
            form.append(plata.suma.toString(), withName: "suma");
          },
          deserializer: (json) {
            return Plata.fromJson(json);
          });
    } on ApiException catch (e) {
      print('Error adding plata: ${e.errorBody}');
      rethrow;
    }
  }

  Future<Plata> updatePlata(Plata plata) async {
    try {
      return await multiPartRequest(
          path: "plati/${plata.id}",
          multipartEncoding: (form) {
            form.append(plata.metoda, withName: "metoda");
            form.append(plata.suma.toString(), withName: "suma");
          },
          deserializer: (json) {
            return Plata.fromJson(json);
          });
    } on ApiException catch (e) {
      print('Error updating plata: ${e.errorBody}');
      rethrow;
    }
  }

  Future<void> deletePlata(int id) async {
    return post(path: "plati/delete/$id", deserializer: (json) {});
  }

  Future<List<Angajat>> fetchAngajati() async {
    return get(
        path: "angajati",
        deserializer: (json) {
          return (json["data"] as List<dynamic>)
              .map((clientJson) => Angajat.fromJson(clientJson))
              .toList();
        });
  }

  Future<Angajat> addAngajat(Angajat angajat) async {
    try {
      return await multiPartRequest(
          path: "angajati/add",
          multipartEncoding: (form) {
            form.append(angajat.nume, withName: "nume");
            form.append(angajat.functie, withName: "functie");
          },
          deserializer: (json) {
            return Angajat.fromJson(json);
          });
    } on ApiException catch (e) {
      print('Error adding angajat: ${e.errorBody}');
      rethrow;
    }
  }

  Future<Angajat> updateAngajat(Angajat angajat) async {
    try {
      return await multiPartRequest(
          path: "angajati/${angajat.id}",
          multipartEncoding: (form) {
            form.append(angajat.nume, withName: "nume");
            form.append(angajat.functie, withName: "functie");
          },
          deserializer: (json) {
            return Angajat.fromJson(json);
          });
    } on ApiException catch (e) {
      print('Error updating angajat: ${e.errorBody}');
      rethrow;
    }
  }

  Future<void> deleteAngajat(int id) async {
    return post(path: "angajati/delete/$id", deserializer: (json) {});
  }

  Future<List<Eveniment>> fetchEvenimente() async {
    return get(
        path: "evenimente",
        deserializer: (json) {
          return (json["data"] as List<dynamic>)
              .map((clientJson) => Eveniment.fromJSON(clientJson))
              .toList();
        });
  }

  Future<Eveniment> addEveniment(Eveniment eveniment) async {
    try {
      return await multiPartRequest(
          path: "evenimente/add",
          multipartEncoding: (form) {
            form.append(eveniment.nume, withName: "nume");
            form.append(eveniment.data.toIso8601String(), withName: "data");
          },
          deserializer: (json) {
            return Eveniment.fromJSON(json);
          });
    } on ApiException catch (e) {
      print('Error adding eveniment: ${e.errorBody}');
      rethrow;
    }
  }

  Future<Eveniment> updateEveniment(Eveniment eveniment) async {
    try {
      return await multiPartRequest(
          path: "evenimente/${eveniment.id}",
          multipartEncoding: (form) {
            form.append(eveniment.nume, withName: "nume");
            form.append(eveniment.data.toIso8601String(), withName: "data");
          },
          deserializer: (json) {
            return Eveniment.fromJSON(json);
          });
    } on ApiException catch (e) {
      print('Error updating eveniment: ${e.errorBody}');
      rethrow;
    }
  }

  Future<void> deleteEveniment(int id) async {
    return post(path: "evenimente/delete/$id", deserializer: (json) {});
  }
}
