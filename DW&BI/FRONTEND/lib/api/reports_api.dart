import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';

final class ReportsApi extends ClientApi {
  ReportsApi() : super(baseURL: selectedApiType.baseUrl);

  Future<List<Map<String, dynamic>>> fetchRaport1() async {
    return get(
      path: "dw/raport1_camere_decembrie", 
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchRaport2() async {
    return get(
      path: "dw/raport2_clienti_evenimente",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchRaport3() async {
    return get(
      path: "dw/raport3_evolutie_servicii",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchRaport4() async {
    return get(
      path: "dw/raport4_metode_plata",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchRaport5() async {
    return get(
      path: "dw/raport5_top_clienti",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }
}