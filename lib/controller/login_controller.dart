import 'dart:convert';

import 'package:alama_eorder_app/api/url.dart';
import 'package:alama_eorder_app/utils/pref_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/request.dart';
import '../model/loginmodel.dart';
import '../utils/constant.dart';

class loginController extends GetxController {
  TextEditingController emailtext = TextEditingController();
  TextEditingController passwordtext = TextEditingController();
  late SharedPreferences _prefs;
  var isLoading = false.obs;

  Future<void> onInit() async {
    await _initializePreferences();
    super.onInit();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void login() async {
    isLoading.value = true;
    Map<String, dynamic> requestData = {
      "userName": "${emailtext.text.trim()}",
      "password": "${passwordtext.text.trim()}"
    };
    if (kDebugMode) {
      print(requestData);
    }
    RequestDio request = RequestDio(url: loginUrl, body: requestData);
    request.post().then((response) async {
      if (response.statusCode == 200) {
        var data = response.data;
        loginmodel success = loginmodel.fromJson(jsonDecode(data));
        if (success.status == true) {
          if (success.isAdmin == true) {
            await Prefs.setBoolen('isLoggedIn', true);
            await Prefs.setBoolen(SHARED_ADMIN, success.isAdmin!);
            await Prefs.setString(TOKEN, success.token!);
            await Prefs.setString(USERNAME,emailtext.text);
            Fluttertoast.showToast(msg: "login-successfully");
            Get.offAllNamed(ROUTE_HOME);
          } else {
            Prefs.setBoolen('isLoggedIn', true);
            Prefs.setBoolen(SHARED_ADMIN, success.isAdmin!);
            await Prefs.setString(TOKEN, success.token!);
            await Prefs.setString(FRANCHISESTATE, success.franchiseState!);
            Fluttertoast.showToast(msg: "login-successfully");
            await Prefs.setString(USERNAME,emailtext.text);
            Get.offAllNamed(ROUTE_HOME);
          }
        } else {
          Prefs.setBoolen('isLoggedIn', false);
          Get.snackbar("Info", "Log-In failed",
              colorText: Colors.white,
              backgroundColor: Colors.blue,
              snackPosition: SnackPosition.TOP);
        }
        isLoading.value = false;
      } else if (response.statusCode == 201) {
        var data = response.data;
        loginmodel success = loginmodel.fromJson(jsonDecode(data));
        if (success.status == true) {
          if (success.isAdmin == true) {
            await Prefs.setBoolen('isLoggedIn', true);
            await Prefs.setBoolen(SHARED_ADMIN, success.isAdmin!);
            await Prefs.setString(TOKEN, success.token!);
            Fluttertoast.showToast(msg: "login-successfully");
            await Prefs.setString(USERNAME,emailtext.text);
            Get.offAllNamed(ROUTE_HOME);
          } else {
            Prefs.setBoolen('isLoggedIn', true);
            Prefs.setBoolen(SHARED_ADMIN, success.isAdmin!);
            await Prefs.setString(TOKEN, success.token!);
            Fluttertoast.showToast(msg: "login-successfully");
            await Prefs.setString(USERNAME,emailtext.text);
            Get.offAllNamed(ROUTE_HOME);
          }
        } else {
          Prefs.setBoolen('isLoggedIn', false);
          Get.snackbar("Info", "Log-In failed",
              colorText: Colors.white,
              backgroundColor: Colors.blue,
              snackPosition: SnackPosition.TOP);
        }
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
      Get.snackbar("Error", "$error",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
    });
  }
}
