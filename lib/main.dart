import 'package:co2_app_server/models/api.dart';
import 'package:co2_app_server/screens/Biological.dart';
import 'package:co2_app_server/screens/Chemical.dart';
import 'package:co2_app_server/screens/Device.dart';
import 'package:co2_app_server/screens/Diagnostic.dart';
import 'package:co2_app_server/screens/DiagnosticList.dart';
import 'package:co2_app_server/screens/FIeldMapEdit.dart';
import 'package:co2_app_server/screens/FieldEdit.dart';
import 'package:co2_app_server/screens/Map.dart';
import 'package:co2_app_server/screens/MyDevices.dart';
import 'package:co2_app_server/screens/DevicesList.dart';
import 'package:co2_app_server/screens/DiagnosticOld.dart';
import 'package:co2_app_server/screens/Fields.dart';
import 'package:co2_app_server/screens/Login.dart';
import 'package:co2_app_server/screens/FieldInfo.dart';
import 'package:co2_app_server/screens/Physical.dart';
import 'package:co2_app_server/screens/Recommend.dart';
import 'package:co2_app_server/screens/Shop.dart';
import 'package:co2_app_server/utils/notice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'HomeScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {

  var api = Api();

  GetIt.I.registerLazySingleton<Api>(() => api);
  WidgetsFlutterBinding.ensureInitialized();
  await Notify.init();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Almaty'));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final dio = Dio();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Argo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/map': (context) => MapScreen(),
        '/shop': (context) => ShopScreen(),
        '/fields': (context) => FieldsScreen(),
        '/field': (context) => MyFieldScreen(),
        '/field/edit': (context) => FieldScreen(),
        '/field/edit/map': (context) => FieldMapEditScreen(),
        '/field/diagnostics': (context) => DiagnosticListScreen(),
        '/devices': (context) => DevicesScreen(),
        '/device': (context) => DeviceScreen(),
        '/devices/list': (context) => DevicesListScreen(),
        '/devices/diagnostic': (context) => DiagnosticScreen(),
        '/recommends': (context) => RecommendTab(),
        '/recommend/biological': (context) => BiologicalScreen(),
        '/recommend/physical': (context) => PhysicalScreen(),
        '/recommend/chemical': (context) => ChemicalScreen(),
      },
    );
  }
}


