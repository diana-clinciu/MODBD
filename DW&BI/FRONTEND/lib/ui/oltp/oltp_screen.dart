import 'package:flutter/material.dart';
import 'package:mvvm_flutter/ui/oltp/oltp_view_model.dart';
import 'package:provider/provider.dart';

class OltpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OLTPViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("OLTP - Hotel Manager"),
        ),
        body: Consumer<OLTPViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection("Clienți", vm.clients.map((c) => "${c.nume} ${c.prenume}").toList()),
                  _buildSection("Rezervări", vm.rezervari.map((r) => "${r.clientName} - ${r.data.toLocal().toShortDateString()}").toList()),
                  _buildSection("Camere", vm.camere.map((c) => "${c.nr} - ${c.tip} - ${c.pret} RON").toList()),
                  _buildSection("Servicii", vm.servicii.map((s) => "${s.denumire} - ${s.pret} RON").toList()),
                  _buildSection("Plăți", vm.plati.map((p) => "${p.id} - ${p.suma} RON - ${p.metoda}").toList()),
                  _buildSection("Angajați", vm.angajati.map((a) => "${a.nume} - ${a.functie}").toList()),
                  _buildSection("Evenimente", vm.evenimente.map((e) => "${e.nume} - ${e.data.toLocal().toShortDateString()}").toList()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ...items.map((i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(i, style: TextStyle(fontSize: 16)),
              )),
        ],
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return "${this.day}/${this.month}/${this.year}";
  }
}
