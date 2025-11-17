import 'package:flutter/material.dart';
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
          return Scaffold(
            appBar: AppBar(title: Text("Rapoarte Grafice")),
            body: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(),
              series: <CartesianSeries>[
                ColumnSeries<ReportData, String>(
                  dataSource: vm.bookingsPerRoom,
                  xValueMapper: (data, _) => data.label,
                  yValueMapper: (data, _) => data.value,
                  color: Colors.blue,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
