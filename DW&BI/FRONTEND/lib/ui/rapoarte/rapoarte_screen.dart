import 'package:flutter/material.dart';
import 'package:mvvm_flutter/models/report_data.dart';
import 'package:mvvm_flutter/ui/rapoarte/rapoarte_view_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';

class ReportsView extends StatelessWidget {
  final List<Color> chartColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.pink,
    Colors.indigo,
  ];

  ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportsViewModel(),
      child: Consumer<ReportsViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (vm.errorMessage != null) {
            return Scaffold(
                body: Center(child: Text('Eroare: ${vm.errorMessage}')));
          }

          return Scaffold(
            appBar: AppBar(title: const Text("Rapoarte Business Intelligence")),
            body: ListView(
              padding: EdgeInsets.only(bottom: 30),
              children: vm.allReports.entries.map((entry) {
                final reportName = entry.key;
                final data = entry.value;

                if (data.isEmpty) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("$reportName: Nu exista date."),
                    ),
                  );
                }

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reportName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackForestColor),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 300,
                          child: _buildChart(reportName, data),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart(String reportName, List<ReportData> data) {
    switch (reportName) {
      case '1. Total Platit / Camera':
        return SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            ColumnSeries<ReportData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              pointColorMapper: (d, index) =>
                  chartColors[index % chartColors.length],
              dataLabelSettings: DataLabelSettings(isVisible: true),
            )
          ],
        );

      case '2. Total Platit / Client (Evenimente)':
        return SfCircularChart(
          legend: Legend(
              isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CircularSeries>[
            PieSeries<ReportData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              pointColorMapper: (d, index) =>
                  chartColors[index % chartColors.length],
              dataLabelSettings: DataLabelSettings(isVisible: true),
            )
          ],
        );

      case '3. Evolutie Venituri Servicii (Sapt.)':
        return SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            LineSeries<ReportData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              markerSettings: MarkerSettings(isVisible: true),
              color: Colors.green,
            )
          ],
        );

      case '4. Plati / Camera & Metoda':
        return SfCartesianChart(
          primaryXAxis: CategoryAxis(
            labelIntersectAction: AxisLabelIntersectAction.rotate45,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            ColumnSeries<ReportData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              pointColorMapper: (d, index) =>
                  chartColors[index % chartColors.length],
              dataLabelSettings: DataLabelSettings(isVisible: true),
            )
          ],
        );

      case '5. Top 5 Clienti Cheltuitori':
        return SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            BarSeries<ReportData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              pointColorMapper: (d, index) =>
                  chartColors[index % chartColors.length],
              dataLabelSettings: DataLabelSettings(isVisible: true),
            )
          ],
        );

      default:
        return Center(child: Text("Tip de raport necunoscut"));
    }
  }
}
