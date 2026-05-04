import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/api/local_api.dart';
import 'package:mvvm_flutter/api/global_api.dart';

class ApiModule {
  static void registerAllServices() {
    GetIt getIt = GetIt.instance;

    getIt.registerSingleton<LocalApi>(LocalApi());
    getIt.registerSingleton<GlobalApi>(GlobalApi());
  }
}
