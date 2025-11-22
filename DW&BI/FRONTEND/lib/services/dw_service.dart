import 'package:mvvm_flutter/api/dw_api.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/models/dim_camera.dart';
import 'package:mvvm_flutter/models/dim_client.dart';
import 'package:mvvm_flutter/models/dim_eveniment.dart';
import 'package:mvvm_flutter/models/dim_metoda_plata.dart';
import 'package:mvvm_flutter/models/dim_serviciu.dart';
import 'package:mvvm_flutter/models/dim_timp.dart';
import 'package:mvvm_flutter/models/fact_rezervari.dart';
import 'package:mvvm_flutter/services/otlp_service.dart';

class DwService {
  final DwApi bookingApi = GetIt.instance.get<DwApi>();

  List<DimClient> dimClients = [];
  List<DimCamera> dimCamere = [];
  List<DimServiciu> dimServicii = [];
  List<DimEveniment> dimEvenimente = [];
  List<DimTimp> dimTimp = [];
  List<DimMetodaPlata> dimMetodePlata = [];
  List<FactRezervari> factRezervari = [];

  void updateFromOtlp(OtlpService oltpService) {
    dimClients = oltpService.clients
        .map((c) => DimClient(c.id, c.nume, c.prenume, c.email))
        .toList();

    dimCamere = oltpService.camere
        .map((c) => DimCamera(c.nr, c.nr, c.tip, c.pret))
        .toList();

    dimServicii = oltpService.servicii
        .map((s) => DimServiciu(s.denumire.hashCode, s.denumire, s.pret))
        .toList();

    dimEvenimente = oltpService.evenimente
        .map((e) => DimEveniment(e.nume.hashCode, e.nume, e.data))
        .toList();

    final allDates = <DateTime>[
      ...oltpService.rezervari.map((r) => r.data),
      ...oltpService.evenimente.map((e) => e.data),
    ];

    dimTimp = allDates.map((d) {
      return DimTimp(
        timpKey: d.millisecondsSinceEpoch,
        dataCompleta: d,
        zi: d.day,
        luna: d.month,
        an: d.year,
      );
    }).toList();

    dimMetodePlata = oltpService.plati
        .map((p) => DimMetodaPlata(plataKey: p.id, metoda: p.metoda))
        .toList();

    factRezervari = oltpService.rezervari.map((r) {
      final client = oltpService.clients
          .firstWhere((c) => "${c.nume} ${c.prenume}" == r.clientName);
      final camera = oltpService.camere.first;
      final serviciu = oltpService.servicii.first;
      final eveniment = oltpService.evenimente.first;
      final timp = dimTimp.firstWhere((t) => t.dataCompleta == r.data);
      final plata = dimMetodePlata.first;
      return FactRezervari(
          r.id,
          "${client.nume} ${client.prenume}",
          "${camera.tip}",
          "${serviciu.denumire}",
          "${eveniment.nume}",
          timp.dataCompleta,
          plata.metoda.hashCode.toDouble());
    }).toList();
  }
}
