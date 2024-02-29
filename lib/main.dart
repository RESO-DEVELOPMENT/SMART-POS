import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pos/screens/home.dart';
import 'package:smart_pos/theme/theme.dart';

import 'screens/login.dart';
import 'screens/not_found_screen.dart';
import 'screens/startup.dart';
import 'setup.dart';
import 'utils/routes_constraints.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  createRouteBindings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart POS',
      debugShowCheckedModeBanner: false,
      theme: light(),
      getPages: [
        GetPage(
            name: RouteHandler.WELCOME,
            page: () => const StartUpView(),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.LOGIN,
            page: () => const LogInScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.HOME,
            page: () => HomeScreen(),
            transition: Transition.circularReveal),
        // GetPage(
        //     name: RouteHandler.PRINTER,
        //     page: () => ScanBluetoohPrinter(),
        //     transition: Transition.cupertino),
      ],
      initialRoute: RouteHandler.WELCOME,
      unknownRoute:
          GetPage(name: RouteHandler.NAV, page: () => const NotFoundScreen()),
    );
  }
}
