import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../api/request.dart';
import '../api/url.dart';
import '../model/registermodel.dart';
import '../model/studentmodel.dart';
import '../utils/constant.dart';

class OrderController extends GetxController {
  var isLoading = false.obs;
  bool isDataInitialized = false;
  TextEditingController programText = TextEditingController();
  late List<String> BookList = [];
  var studentId = "".obs;
  var currentlevel = "".obs;
  var futurelevel = "".obs;
  late final SData data;
  @override
  void onInit() {
    if (kDebugMode) {
      print('Order controller start');
    }
    super.onInit();
  }

  void tell() {
    int currentLevel = int.parse(currentlevel.value.split(' ')[1]);
    if (data.program == 'MA') {
      programText.text = data.program!;
      BookList = [
        'MA AS PAPER L${currentLevel}', //MA AS PAPER L1 == level1MA
        'MA CB${currentLevel}', //cb1MA
        'MA PB${currentLevel}'
      ];
    } else if (data.program == 'AA' && currentLevel == 6) {
      futurelevel.value = 'Level 5';
      programText.text = 'MA';
    } else {
      print('AA program');
      programText.text = data.program!;
      BookList = [
        'AA ASS PAPER L${currentLevel}',
        'AA CB$currentLevel',
        'AA PB${currentLevel}'
      ];
    }
  }

  void backendformat() {
    int currentLevel = int.parse(currentlevel.value.split(' ')[1]);
    if (data.program == 'MA') {
      BookList = [
        'level${currentLevel}MA', //MA AS PAPER L1 == level1MA
        'cb${currentLevel}MA', //cb1MA
        'pb${currentLevel}MA'
      ];
    } else {
      print('AA program');
      BookList = [
        'level${currentLevel}AA', //MA AS PAPER L1 == level1MA
        'cb${currentLevel}AA', //cb1MA
        'pb${currentLevel}AA'
      ];
    }
  }

  void updateOrder() {
    backendformat();
    isLoading.value = true;
    Map<String, dynamic> requestData = {
      "studentID": "${data.studentID}",
      "futureLevel": "${futurelevel.value}",
      "currentLevel": "${currentlevel.value}",
      "items": BookList
    };
    if (kDebugMode) {
      print(requestData);
    }
    RequestDio request = RequestDio(url: getallordersUrl, body: requestData);
    request.post().then((response) async {
      if (kDebugMode) {
        print(response.data);
      }
      if (response.statusCode == 200) {
        registrationsuccessmodel success =
            registrationsuccessmodel.fromJson(response.data);
        if (success.status == true) {
          Fluttertoast.showToast(msg: success.message!);
          isLoading.value = false;
          update();
          Get.offAllNamed(ROUTE_HOME);
        } else {
          Fluttertoast.showToast(msg: success.message!);
          isLoading.value = false;
          update();
        }
      } else if (response.statusCode == 201) {
        registrationsuccessmodel success =
            registrationsuccessmodel.fromJson(response.data);
        if (success.status == true) {
          Fluttertoast.showToast(msg: success.message!);
          isLoading.value = false;
          update();
          Get.back();
        } else {
          Fluttertoast.showToast(msg: success.message!);
          isLoading.value = false;
          update();
        }
      } else {
        Get.snackbar("Error", "Please try later",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP);
      }
    });
  }
}
