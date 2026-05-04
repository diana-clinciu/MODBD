import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mvvm_flutter/services/global_service.dart';

class _DistributieEntry {
  final String? fragment;
  final int count;
  _DistributieEntry(this.fragment, this.count);
}

class StatisticiViewModel extends ChangeNotifier {
  final GlobalService _service = GetIt.instance.get<GlobalService>();

  bool loading = false;
  String? error;

  List<_DistributieEntry> hotelData = [];
  List<_DistributieEntry> angajatData = [];
  List<_DistributieEntry> cameraData = [];

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final raw = await _service.fetchDistributie();
      hotelData = raw
          .where((e) => e['entitate'] == 'hotel')
          .map((e) =>
              _DistributieEntry(e['fragment'] as String?, e['count'] as int))
          .toList();
      angajatData = raw
          .where((e) => e['entitate'] == 'angajat')
          .map((e) =>
              _DistributieEntry(e['fragment'] as String?, e['count'] as int))
          .toList();
      cameraData = raw
          .where((e) => e['entitate'] == 'camera')
          .map((e) =>
              _DistributieEntry(e['fragment'] as String?, e['count'] as int))
          .toList();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }
}

class StatisticiScreen extends StatefulWidget {
  const StatisticiScreen({super.key});

  @override
  State<StatisticiScreen> createState() => _StatisticiScreenState();
}

class _StatisticiScreenState extends State<StatisticiScreen> {
  final StatisticiViewModel _vm = StatisticiViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _vm.load());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StatisticiViewModel>.value(
      value: _vm,
      child: Consumer<StatisticiViewModel>(
        builder: (ctx, vm, _) {
          if (vm.loading) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (vm.error != null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Eroare: ${vm.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: vm.load,
                        child: const Text('Reincearca')),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Distributie Date per Fragment'),
              actions: [
                IconButton(
                    icon: const Icon(Icons.refresh), onPressed: vm.load),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildChart('Hoteluri', vm.hotelData, Colors.blue),
                const SizedBox(height: 12),
                _buildChart('Angajati', vm.angajatData, Colors.orange),
                const SizedBox(height: 12),
                _buildChart('Camere', vm.cameraData, Colors.green),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart(
      String? title, List<_DistributieEntry> data, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title ?? '',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                primaryYAxis: const NumericAxis(minimum: 0),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  ColumnSeries<_DistributieEntry, String?>(
                    dataSource: data,
                    xValueMapper: (e, _) => e.fragment,
                    yValueMapper: (e, _) => e.count,
                    color: color,
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: true),
                    name: title,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
