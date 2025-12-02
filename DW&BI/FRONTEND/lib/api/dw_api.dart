import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';

final class DwApi extends ClientApi {
  DwApi() : super(baseURL: selectedApiType.baseUrl);

  Future<Map<String, int>> syncDw() async {
    try {
      return await multiPartRequest(
        path: "dw/sync",
        multipartEncoding: (form) {},
        deserializer: (json) {
          if (json is Map<String, dynamic>) {
            return json.map((key, value) => MapEntry(key, value as int));
          } else {
            throw Exception("Format răspuns invalid: ${json.runtimeType}");
          }
        },
      );
    } on ApiException catch (e) {
      print('Error syncing DW: ${e.errorBody}');
      rethrow;
    }
  }
}
