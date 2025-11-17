import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/api/dw_api.dart';
import 'package:mvvm_flutter/api/otlp_api.dart';
import 'package:mvvm_flutter/api/reports_api.dart';

class ApiModule {
  static void registerAllServices() {
    GetIt getIt = GetIt.instance;

    getIt.registerSingleton<OtlpApi>(OtlpApi());
    getIt.registerSingleton<DwApi>(DwApi());
    getIt.registerSingleton<ReportsApi>(ReportsApi());
  }
}
