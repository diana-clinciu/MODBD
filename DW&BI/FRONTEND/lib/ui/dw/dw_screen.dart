import 'package:flutter/material.dart';
import 'package:mvvm_flutter/ui/dw/dw_view_model.dart';
import 'package:provider/provider.dart';

class DWScreen extends StatefulWidget {
  @override
  State<DWScreen> createState() => _DWViewState();
}

class _DWViewState extends State<DWScreen> {
  final TextEditingController _filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DWViewModel(),
      child: Consumer<DWViewModel>(
        builder: (context, vm, _) {
          List<FactRezervari> filteredFact = _filterController.text.isEmpty
              ? vm.factRezervari
              : vm.filterFactByClient(_filterController.text);

          return Scaffold(
            appBar: AppBar(
              title: Text("DW - Propagare OLTP → DW"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: vm.propagateChanges,
                    child: Text("Propagare modificări OLTP → DW"),
                  ),
                  SizedBox(height: 12),
                  Text(vm.statusMessage, style: TextStyle(color: Colors.green)),
                  SizedBox(height: 16),
                  TextField(
                    controller: _filterController,
                    decoration: InputDecoration(
                      labelText: "Filtrare fact rezervări după client",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: filteredFact
                          .map((f) => Card(
                                child: ListTile(
                                  title: Text("${f.client} - ${f.rezervareKey}"),
                                  subtitle: Text(
                                      "Cameră: ${f.camera}, Serviciu: ${f.serviciu}, Eveniment: ${f.eveniment}\nData: ${f.data.toShortDateString()}, Sumă: ${f.suma} RON"),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return "${this.day}/${this.month}/${this.year}";
  }
}
