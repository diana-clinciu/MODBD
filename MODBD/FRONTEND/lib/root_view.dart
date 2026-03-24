import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/root_view_model.dart';
import 'package:mvvm_flutter/ui/navigator/navigator_router.dart';
import 'package:mvvm_flutter/ui/reusable_components/loader_view.dart';
import 'package:mvvm_flutter/ui/tab_view/tab_scren.dart';

class RootView extends StatefulWidget {
  RootView({Key? key}) : super(key: key);

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  final NavigationRouter _navigationRouter =
      GetIt.instance.get<NavigationRouter>();

  late final RootViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = RootViewModel();

    _navigationRouter.push(_loadingScreen().asNavigationDestination());

    _navigationRouter.replaceNavigationStack([
      TabScreen().asNavigationDestination(),
    ]);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: _navigationRouter,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }

  Widget _loadingScreen() {
    return Scaffold(
      body: LoaderView(),
    );
  }
}
