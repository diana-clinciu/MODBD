import 'package:flutter/material.dart';

class ReportData {
  final String label;
  final double value;
  ReportData(this.label, this.value);
}

class ReportsViewModel extends ChangeNotifier {
  List<ReportData> bookingsPerRoom = [];

  ReportsViewModel() {
    bookingsPerRoom = [
      ReportData("Single", 15),
      ReportData("Double", 20),
      ReportData("Suite", 10),
    ];
  }
}