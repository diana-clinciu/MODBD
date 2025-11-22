import 'package:mvvm_flutter/api/client_api.dart';

class DimCamera {
  final int cameraKey;
  final int nrCamera;
  final String tip;
  final double pret;

  DimCamera(this.cameraKey, this.nrCamera, this.tip, this.pret);

  static DimCamera fromJson(JSON jsonBody) {
    return DimCamera(
      jsonBody['cameraKey'],
      jsonBody['nrCamera'],
      jsonBody['tip'],
      jsonBody['pret'],
    );
  }
}