import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';

final class ReportsApi extends ClientApi {
  ReportsApi() : super(baseURL: selectedApiType.baseUrl);

  Future<List<Map<String, dynamic>>> fetchRaport1() async {
    return get(
      path: "dw/raport1_venituri_lunare",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchRaport2() async {
    return get(
      path: "dw/raport2_venit_metoda_plata",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchRaport3() async {
    return get(
      path: "dw/raport3_top_clienti_vip",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchRaport4() async {
    return get(
      path: "dw/raport4_venituri_anuale",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchRaport5() async {
    return get(
      path: "dw/raport5_top_camere_per_metoda",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }
}
