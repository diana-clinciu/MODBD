import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/services/reports_service.dart';

class ReportData {
  final String label;
  final double value;
  ReportData(this.label, this.value);
}

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
        'Raport 1': raport1.map(_mapToReportData1).toList(),
        'Raport 2': raport2.map(_mapToReportData2).toList(),
        'Raport 3': raport3.map(_mapToReportData3).toList(),
        'Raport 4': raport4.map(_mapToReportData4).toList(),
        'Raport 5': raport5.map(_mapToReportData5).toList(),
      };

      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      allReports = {};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ReportData _mapToReportData1(Map<String, dynamic> e) {
    return ReportData(
      e['Tip_Camara']?.toString() ?? '',
      (e['Suma_Totala_Platita_Dec_2025'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ReportData _mapToReportData2(Map<String, dynamic> e) {
    return ReportData(
      e['Alt_Label']?.toString() ?? '',
      (e['Alt_Value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ReportData _mapToReportData3(Map<String, dynamic> e) {
    return ReportData(
      e['Label3']?.toString() ?? '',
      (e['Value3'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ReportData _mapToReportData4(Map<String, dynamic> e) {
    return ReportData(
      e['Label4']?.toString() ?? '',
      (e['Value4'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ReportData _mapToReportData5(Map<String, dynamic> e) {
    return ReportData(
      e['Label5']?.toString() ?? '',
      (e['Value5'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
