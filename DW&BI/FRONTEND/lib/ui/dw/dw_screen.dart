import 'package:flutter/material.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';
import 'package:mvvm_flutter/utils/extensions/color+.dart';
import 'package:provider/provider.dart';
import 'dw_view_model.dart';

class DWScreen extends StatelessWidget {
  const DWScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DWViewModel(),
      child: const DWScreenContent(),
    );
  }
}

class DWScreenContent extends StatelessWidget {
  const DWScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DWViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cauta in rezultate...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: vm.filterResults,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightCaramelColor,
                  foregroundColor: AppColors.blackForestColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: vm.isLoading ? null : vm.syncToDW,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sync),
                    const SizedBox(width: 10),
                    Text(
                      vm.isLoading
                          ? "Se sincronizeaza..."
                          : "Sincronizeaza OLTP → DW",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (vm.isLoading) ...[
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 16),
          ],
          if (vm.syncCompleted) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Rezultate in DW",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 12),
            ListView.builder(
              itemCount: vm.filteredInsertedResults.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final entries = vm.filteredInsertedResults.entries.toList();
                final key = entries[index].key;
                final value = entries[index].value;

                final label = key
                    .replaceAll('_inserted', '')
                    .replaceAll('dim_', '')
                    .replaceAll('_', ' ')
                    .toUpperCase();

                return Card(
                  color: AppColors.oliveColor.withTransparency(0.5),
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: AppColors.blackForestColor,
                    ),
                    title: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text("Randuri noi propagate: $value"),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            if (vm.totalResults.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightCaramelColor.withTransparency(0.5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withTransparency(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total inregistrari in DW",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...vm.totalResults.entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            "• ${e.key}: ${e.value}",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
