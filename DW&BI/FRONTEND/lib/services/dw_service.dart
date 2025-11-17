import 'package:mvvm_flutter/api/dw_api.dart';
import 'package:get_it/get_it.dart';

class DwService {
  final DwApi bookingApi = GetIt.instance.get<DwApi>();
}
