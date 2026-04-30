import 'dart:io';

import 'package:alama_eorder_app/pages/app_route.dart';
import 'package:alama_eorder_app/utils/colorUtils.dart';
import 'package:alama_eorder_app/utils/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'View/Splash_Screen.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          color: primaryColor, // Set default app bar color to red
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor, // Set elevated button color to blue
          ),
        ),
        iconTheme: IconThemeData(
          color: secondaryColor, // Set default icon color to secondaryColor
        ),
      ),
      home: const SplashScreen(),
      getPages: AppPages.pages,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaleFactor.clamp(0.9, 0.9);
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: scale), child: child!);
      },
    );
  }
}
