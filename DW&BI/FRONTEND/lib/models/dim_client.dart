import 'package:mvvm_flutter/api/client_api.dart';

class DimClient {
  final int clientKey;
  final String nume;
  final String prenume;
  final String email;

  DimClient(this.clientKey, this.nume, this.prenume, this.email);

  static DimClient fromJson(JSON jsonBody) {
    return DimClient(
      jsonBody['clientKey'],
      jsonBody['nume'],
      jsonBody['prenume'],
      jsonBody['email'],
    );
  }
}