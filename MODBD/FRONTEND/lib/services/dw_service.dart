import 'package:mvvm_flutter/api/dw_api.dart';
import 'package:get_it/get_it.dart';

class DwService {
  final DwApi bookingApi = GetIt.instance.get<DwApi>();

  Future<Map<String, int>> syncDw() async {
    final response = await bookingApi.syncDw();
    return response;
  }
}
