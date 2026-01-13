import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/models/report_data.dart';
import 'package:mvvm_flutter/services/reports_service.dart';

class ReportsViewModel extends ChangeNotifier {
  final ReportsService _service = GetIt.instance.get<ReportsService>();

  Map<String, List<ReportData>> allReports = {};
  bool isLoading = false;
  String? errorMessage;

  ReportsViewModel() {
    fetchAllReports();
  }

  Future<void> fetchAllReports() async {
    isLoading = true;
    notifyListeners();

    try {
      final raport1 = await _service.fetchRaport1();
      final raport2 = await _service.fetchRaport2();
      final raport3 = await _service.fetchRaport3();
      final raport4 = await _service.fetchRaport4();
      final raport5 = await _service.fetchRaport5();

      allReports = {
        '1. Venituri lunare cumulate 2024 & 2025': raport1.isNotEmpty
            ? _mapToReportData1(raport1)
            : [ReportData('Nu exista date', 0)],
        '2. Venit / Metoda Plata': raport2.isNotEmpty
            ? raport2.map(_mapToReportData2).toList()
            : [ReportData('Nu exista date', 0.0)],
        '3. Top 5% Clienti VIP / Categorie':
            raport3.map(_mapToReportData3).toList(),
        '4. Variatia veniturilor trimestriale fata de media anuala':
            raport4.isNotEmpty
                ? raport4.map(_mapToReportData4).toList()
                : [ReportData('Nu exista date', 0.0)],
        '5. Top 3 Camere per Metoda Plata (2024)': raport5.isNotEmpty
            ? raport5.map(_mapToReportData5).toList()
            : [ReportData('Nu exista date', 0.0)],
      };

      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      allReports = {};
      print("Eroare ViewModel: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<ReportData> _mapToReportData1(List<Map<String, dynamic>> data) {
    final List<ReportData> result = [];

    for (final e in data) {
      final luna = e['luna']?.toString() ?? '';

      final v2024 = (e['cumulat_2024'] as num?)?.toDouble() ?? 0.0;
      final v2025 = (e['cumulat_2025'] as num?)?.toDouble() ?? 0.0;

      result.add(ReportData('$luna 2024', v2024));
      result.add(ReportData('$luna 2025', v2025));
    }

    return result;
  }

  ReportData _mapToReportData2(Map<String, dynamic> e) {
    final camera = e['id_camera_dim']?.toString() ?? '';
    final plata = e['metoda_plata']?.toString() ?? '';

    double value = 0.0;

    final rawValue = e['venit_metoda_plata'];
    if (rawValue is num) {
      value = rawValue.toDouble();
    } else if (rawValue is String) {
      value = double.tryParse(rawValue) ?? 0.0;
    }

    return ReportData("$camera\n($plata)", value);
  }

  ReportData _mapToReportData3(Map<String, dynamic> e) {
    final label = e['categorie_camera']?.toString() ?? 'N/A';

    double value = 0.0;

    final rawValue = e['numar_rezervari'];
    if (rawValue is num) {
      value = rawValue.toDouble();
    } else if (rawValue is String) {
      value = double.tryParse(rawValue) ?? 0.0;
    }

    return ReportData(label, value);
  }

  ReportData _mapToReportData4(Map<String, dynamic> e) {
    final categorie = e['categorie_camera']?.toString() ?? 'N/A';
    final trimestru = e['trimestru']?.toString() ?? '';
    final numarRezervari = e['numar_rezervari'] ?? 0;

    final diferentaProcentuala =
        (e['diferenta_procentuala_fata_de_medie_anuala'] as num?)?.toDouble() ??
            0.0;

    return ReportData(
      "$categorie\nTrimestru $trimestru\nRezervari: $numarRezervari",
      diferentaProcentuala,
    );
  }

  ReportData _mapToReportData5(Map<String, dynamic> e) {
    final metoda = e['metoda_plata']?.toString() ?? 'N/A';
    final camera = e['categorie_camera']?.toString() ?? 'N/A';
    final nrCamera = e['nr_camera']?.toString() ?? '';

    final label = "$metoda\n$camera $nrCamera";

    final value = (e['valoare_totala'] as num?)?.toDouble() ?? 0.0;

    return ReportData(label, value);
  }
}
