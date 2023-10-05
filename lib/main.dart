import 'package:alama_eorder_app/pages/app_route.dart';
import 'package:alama_eorder_app/utils/colorUtils.dart';
import 'package:alama_eorder_app/utils/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'View/Splash_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: primaryColor, // Set default app bar color to red
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: secondaryColor, // Set elevated button color to blue
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
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
            child: child!);
      },
    );
  }
}
