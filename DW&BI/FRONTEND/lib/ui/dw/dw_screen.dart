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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cauta in rezultate...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (query) {
              vm.filterResults(query);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightCaramelColor,
                foregroundColor: AppColors.blackForestColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: vm.isLoading ? null : vm.syncToDW,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sync),
                  SizedBox(width: 10),
                  Text(
                    vm.isLoading
                        ? "Se sincronizeaza..."
                        : "Sincronizeaza OLTP → DW",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackForestColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (vm.isLoading) ...[
          CircularProgressIndicator(),
          SizedBox(height: 16),
        ],
        if (vm.syncCompleted) ...[
          SizedBox(height: 16),
          Text(
            "Rezultate in DW:",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.blackForestColor),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: vm.filteredResults.length,
              itemBuilder: (context, index) {
                // Convertim Map în List pentru indexare
                final entries = vm.filteredResults.entries.toList();
                final key = entries[index].key;
                final value = entries[index].value;

                return Card(
                  color: AppColors.oliveColor.withTransparency(0.5),
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      "$key: $value randuri propagate",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.contentPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]
      ],
    );
  }
}
