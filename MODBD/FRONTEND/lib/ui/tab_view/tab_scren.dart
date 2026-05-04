import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/ui/local/local_screen.dart';
import 'package:mvvm_flutter/ui/global/global_screen.dart';
import 'package:mvvm_flutter/ui/statistici/statistici_screen.dart';
import 'package:mvvm_flutter/ui/reusable_components/keep_alive.dart';
import 'package:mvvm_flutter/ui/tab_view/tab_view_model.dart';
import 'package:provider/provider.dart';
import 'bottom_nav_bar.dart';

class TabScreen extends StatelessWidget {
  final TabViewViewModel _viewModel = GetIt.instance.get<TabViewViewModel>();

  final List<Widget> _pages = const [
    KeepAlivePage(child: LocalScreen()),
    KeepAlivePage(child: GlobalScreen()),
    KeepAlivePage(child: StatisticiScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TabViewViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: BottomNavBar(),
        ),
        body: Consumer<TabViewViewModel>(
          builder: (context, viewModel, child) {
            return IndexedStack(
              index: viewModel.currentIndex,
              children: _pages,
            );
          },
        ),
      ),
    );
  }
}
