import 'dart:async';
import 'package:alama_eorder_app/utils/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colorUtils.dart';
import '../utils/constant.dart';
import '../utils/imageUtils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Animation? _logoAnimation;
  AnimationController? _logoAnimationController;
  bool _isLoggedIn = false;
  late SharedPreferences _prefs;
  String? errorMsg;
  @override
  void initState() {
    super.initState();
 //   _initializePreferences();
    _logoAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _logoAnimation = Tween(begin: 0.0, end: 200.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _logoAnimationController!));

    _logoAnimationController!.addStatusListener((AnimationStatus status) {});
    _logoAnimationController!.forward();

    startTime();
  }

  // Future<void> _initializePreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  // }

  startTime() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, navigationPage);
  }

  void navigationPage() async {
    if (Prefs.getBoolen('isLoggedIn')) {
      Get.offAllNamed(ROUTE_HOME);
    } else {
      Get.offAllNamed(ROUTE_LOGIN);
    }
  }

  @override
  void dispose() {
    super.dispose();
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _logoAnimationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: logocolor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            secondChild(),
          ],
        ),
      ),
    );
  }

  Widget secondChild() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final portraitHeight = screenHeight * 0.3;
    final portraitWidth = screenHeight * 0.4;
    final landscapeHeight = screenHeight * 0.4;
    final landscapeWidth = screenWidth * 0.4;

    return AnimatedBuilder(
      animation: _logoAnimationController!,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.only(left: 30, right: 20, bottom: 5),
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? portraitWidth
              : landscapeWidth,
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? portraitHeight
              : landscapeHeight,
          child: Center(
            child: Image.asset(
              logo,
              width: double.infinity,
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? portraitHeight
                  : landscapeHeight,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
    );
  }
}
