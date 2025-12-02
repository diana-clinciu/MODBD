import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';

final class ReportsApi extends ClientApi {
  ReportsApi() : super(baseURL: selectedApiType.baseUrl);

  // RAPORT 1 - Suma totala platita pentru fiecare tip de camera, decembrie 2025
  Future<List<Map<String, dynamic>>> fetchRaport1() async {
    return get(
      path: "dw/raport1",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  // RAPORT 2 - Numarul de rezervari si suma totala platita de fiecare client la evenimente, decembrie 2025
  Future<List<Map<String, dynamic>>> fetchRaport2() async {
    return get(
      path: "dw/raport2",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  // RAPORT 3 - Evolutia veniturilor generate de servicii pe saptamani, decembrie 2025
  Future<List<Map<String, dynamic>>> fetchRaport3() async {
    return get(
      path: "dw/raport3",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  // RAPORT 4 - Suma totala platita pentru rezervari pe tip camera si metoda de plata
  Future<List<Map<String, dynamic>>> fetchRaport4() async {
    return get(
      path: "dw/raport4",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }

  // RAPORT 5 - Top 5 clienti care au cheltuit cel mai mult in hotel, decembrie 2025
  Future<List<Map<String, dynamic>>> fetchRaport5() async {
    return get(
      path: "dw/raport5",
      deserializer: (json) {
        return (json as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      },
    );
  }
}
