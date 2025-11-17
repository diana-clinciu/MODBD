import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';

final class ReportsApi extends ClientApi {
  ReportsApi() : super(baseURL: selectedApiType.baseUrl);
}
