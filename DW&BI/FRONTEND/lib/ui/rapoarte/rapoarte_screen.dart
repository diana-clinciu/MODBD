import 'package:flutter/material.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';
import 'package:mvvm_flutter/ui/rapoarte/rapoarte_view_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportsView extends StatelessWidget {
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
                body: Center(child: Text('Error: ${vm.errorMessage}')));
          }

          return Scaffold(
            appBar: AppBar(title: Text("Rapoarte Grafice")),
            body: ListView(
              children: vm.allReports.entries.map((entry) {
                final reportName = entry.key;
                final data = entry.value;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reportName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.blackForestColor)),
                      SizedBox(
                        height: 250,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(),
                          series: <CartesianSeries>[
                            ColumnSeries<ReportData, String>(
                              dataSource: data,
                              xValueMapper: (d, _) => d.label,
                              yValueMapper: (d, _) => d.value,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
