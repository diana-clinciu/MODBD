import 'package:mvvm_flutter/api/otlp_api.dart';
import 'package:get_it/get_it.dart';

class OtlpService {
  final OtlpApi bookingApi = GetIt.instance.get<OtlpApi>();
}
