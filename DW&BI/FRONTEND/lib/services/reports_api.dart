import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/api/reports_api.dart';

class ReportsService {
  final ReportsApi bookingApi = GetIt.instance.get<ReportsApi>();
}
