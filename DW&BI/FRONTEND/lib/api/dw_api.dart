import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';

final class DwApi extends ClientApi {
  DwApi() : super(baseURL: selectedApiType.baseUrl);
}
