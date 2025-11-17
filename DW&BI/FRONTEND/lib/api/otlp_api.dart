import 'package:mvvm_flutter/api/api_type.dart';
import 'package:mvvm_flutter/api/client_api.dart';

final class OtlpApi extends ClientApi {
  OtlpApi() : super(baseURL: selectedApiType.baseUrl);
}
