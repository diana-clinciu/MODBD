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
        '1. Total Platit / Camera': raport1.map(_mapToReportData1).toList(),
        '2. Total Platit / Client (Evenimente)': raport2.map(_mapToReportData2).toList(),
        '3. Evolutie Venituri Servicii (Sapt.)': raport3.map(_mapToReportData3).toList(),
        '4. Plati / Camera & Metoda': raport4.map(_mapToReportData4).toList(),
        '5. Top 5 Clienti Cheltuitori': raport5.map(_mapToReportData5).toList(),
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

  ReportData _mapToReportData1(Map<String, dynamic> e) {
    return ReportData(
      e['tip_camera']?.toString() ?? 'N/A', 
      (e['suma_totala_platita_dec_2025'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ReportData _mapToReportData2(Map<String, dynamic> e) {
    return ReportData(
      e['client']?.toString() ?? 'Anonim',
      (e['suma_platita'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ReportData _mapToReportData3(Map<String, dynamic> e) {
    return ReportData(
      "Sapt ${e['saptamana']}", 
      (e['venit_servicii'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ReportData _mapToReportData4(Map<String, dynamic> e) {
    final camera = e['tip_camera']?.toString() ?? '';
    final plata = e['metoda_plata']?.toString() ?? '';
    return ReportData(
      "$camera\n($plata)", 
      (e['suma_totala_rezervari'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ReportData _mapToReportData5(Map<String, dynamic> e) {
    return ReportData(
      e['client']?.toString() ?? 'Anonim',
      (e['suma_platita'] as num?)?.toDouble() ?? 0.0,
    );
  }
}