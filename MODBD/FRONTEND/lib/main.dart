import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';
import 'package:mvvm_flutter/root_view.dart';
import 'package:mvvm_flutter/ui/tab_view/tab_view_model.dart';
import 'package:mvvm_flutter/utils/extensions/color+.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_flutter/api/api_module.dart';
import 'package:mvvm_flutter/services/service_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ApiModule.registerAllServices();
  ServiceModule.registerALlServices();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TabViewViewModel _tabViewModel = GetIt.instance.get<TabViewViewModel>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.creamColor.withTransparency(0.3)),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<TabViewViewModel>.value(
                value: _tabViewModel),
          ],
          child: child!,
        );
      },
      home: _AnimatedHome(),
    );
  }
}

class _AnimatedHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(child: RootView());
  }
}
