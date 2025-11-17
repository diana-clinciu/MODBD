import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/services/dw_service.dart';
import 'package:mvvm_flutter/services/otlp_service.dart';
import 'package:mvvm_flutter/services/reports_api.dart';
import 'package:mvvm_flutter/ui/navigator/navigator_router.dart';
import 'package:mvvm_flutter/ui/tab_view/tab_view_model.dart';

class ServiceModule {
  static void registerALlServices() {
    final GetIt getIt = GetIt.instance;

    getIt.registerSingleton<TabViewViewModel>(TabViewViewModel());
    getIt.registerSingleton<NavigationRouter>(NavigationRouter());
    getIt.registerSingleton<OtlpService>(OtlpService());
    getIt.registerSingleton<DwService>(DwService());
    getIt.registerSingleton<ReportsService>(ReportsService());
  }
}
