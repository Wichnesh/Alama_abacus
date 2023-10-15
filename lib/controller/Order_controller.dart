import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../api/request.dart';
import '../api/url.dart';
import '../model/registermodel.dart';
import '../model/studentmodel.dart';
import '../utils/constant.dart';
import '../utils/pref_manager.dart';

class OrderController extends GetxController {
  var isLoading = false.obs;
  bool isDataInitialized = false;
  TextEditingController programText = TextEditingController();
  late List<String> BookList = [];
  var studentId = "".obs;
  var currentlevel = "".obs;
  var futurelevel = "".obs;
  var gc = false.obs;
  var mc = false.obs;
  var gcstring = "".obs;
  var mcstring = "".obs;
  var enableBtn = false.obs;
  var isChecked = false.obs;
  var state = ''.obs;
  late final SData data;
  @override
  void onInit() {
    if (kDebugMode) {
      print('Order controller start');
    }
    super.onInit();
  }
  var disableBtn = true.obs;
  var transferBool = false.obs;
  void Checkbox(bool newValue) {
    isChecked.value = newValue;
    if (kDebugMode) {
      print(isChecked.value);
    }
    if(isChecked.value){
      disableBtn.value = false;
      transferBool.value = true;
    }else{
      disableBtn.value = true;
      transferBool.value = false;
    }
  }

  void certificatechecker() {
    if (gc.value == true) {
      gcstring.value = "Graduate Certificate";
    } else if (mc.value == true) {
      mcstring.value = "Master Certificate";
    } else {
      gcstring.value = "";
      mcstring.value = "";
    }
  }

  void addBookList() {
   if(isChecked.value){
     if (data.program == 'AA') {
       BookList = [
         'AA ASS PAPER L6',
         'MA CB 5', //cb1MA
         'MA PB 5',
       ];
     }
   }else{
     if (data.program == 'AA') {
       BookList = [
         'AA ASS PAPER L6',
       ];
     }
   }
  }

  void tell() {
    if (currentlevel.value == 'Enroll' || currentlevel.value == 'Pre Level') {
      programText.text = data.program!;
      if (data.program == 'MA') {
        BookList = [
          'MA AS PAPER L1',
          'MA CB 2', //cb1MA
          'MA PB 2',
        ];
        state.value = data.state!;
        enableBtn.value = data.enableBool!;
      } else {
        programText.text = data.program!;
        BookList = [
          'AA AS PAPER L1',
          'AA CB 2', //cb1MA
          'AA PB 2',
        ];
        state.value = data.state!;
        enableBtn.value = data.enableBool!;
      }
    } else {
      int level = int.parse(currentlevel.value.split(' ')[1]) + 2;
      int paperLevel = int.parse(currentlevel.value.split(' ')[1]) + 1;
      int currentLevel = int.parse(currentlevel.value.split(' ')[1]);
      if (data.program == 'MA' && currentLevel == 1) {
        gc.value = true;
        programText.text = data.program!;
        BookList = [
          'MA AS PAPER L${paperLevel}', //MA AS PAPER L1 == level1MA
          'MA CB ${level}', //cb1MA
          'MA PB ${level}',
          'graduate Certificate'
        ];
        state.value = data.state!;
        enableBtn.value = data.enableBool!;
      } else if (data.program == 'MA' && currentLevel == 3) {
        mc.value = true;
        programText.text = data.program!;
        BookList = [
          'MA AS PAPER L${paperLevel}', //MA AS PAPER L1 == level1MA
          'MA CB ${level}', //cb1MA
          'MA PB ${level}',
          'Master Certificate'
        ];
        state.value = data.state!;
        enableBtn.value = data.enableBool!;
      } else if (data.program == 'MA' && currentLevel == 5) {
        programText.text = data.program!;
        BookList = [
          'MA AS PAPER L6', //MA AS PAPER L1 == level1MA
        ];
        disableBtn.value = true;
        state.value = data.state!;
        enableBtn.value = data.enableBool!;
      } else if(data.program == 'MA' && currentLevel == 6){
        programText.text = data.program!;
        BookList = [
          'MA AS PAPER L6', //MA AS PAPER L1 == level1MA
          'Master Certificate'
        ];
        state.value = data.state!;
        enableBtn.value = data.enableBool!;
      }
      else if (data.program == 'MA') {
        programText.text = data.program!;
        BookList = [
          'MA AS PAPER L${paperLevel}', //MA AS PAPER L1 == level1MA
          'MA CB ${level}', //cb1MA
          'MA PB ${level}'
        ];
        state.value = data.state!;
        enableBtn.value = data.enableBool!;
      } else if (data.program == 'AA' && currentLevel == 6) {
        futurelevel.value = 'Level 5';
        programText.text = 'MA';
        BookList = [
          '${programText.text} ASS PAPER L5',
          '${programText.text} CB 6',
          '${programText.text} PB 6',
        ];
        state.value = data.state!;
        enableBtn.value = data.enableBool!;
      } else {
        if (data.program == 'AA' && currentLevel == 2) {
          gc.value = true;
          if (kDebugMode) {
            print('AA program');
          }
          programText.text = data.program!;
          BookList = [
            'AA ASS PAPER L${paperLevel}',
            'AA CB ${level}',
            'AA PB ${level}',
            'Graduate Certificate'
          ];
          state.value = data.state!;
          enableBtn.value = data.enableBool!;
        } else if (data.program == 'AA' && currentLevel == 5) {
          mc.value = true;
          programText.text = data.program!;
          BookList = [
            'AA ASS PAPER L${paperLevel}',
            'Master Certificate'
          ];
          state.value = data.state!;
          enableBtn.value = data.enableBool!;
        }else if(data.program == 'AA' && currentLevel == 6){
          if (kDebugMode) {
            print('AA program');
          }
          programText.text = 'MA';
          BookList = [
            'MA ASS PAPER L5',
            'MA CB 5', //cb1MA
            'MA PB 5',
          ];
          state.value = data.state!;
          enableBtn.value = data.enableBool!;
        } else {
          if (kDebugMode) {
            print('AA program');
          }
          programText.text = data.program!;
          BookList = [
            'AA ASS PAPER L${paperLevel}',
            'AA CB ${level}',
            'AA PB ${level}'
          ];
          state.value = data.state!;
          enableBtn.value = data.enableBool!;
        }
      }
    }
    update();
  }

  void backendformat() {
    if (currentlevel.value == 'Enroll' || currentlevel.value == 'Pre Level') {
      if (data.paymentID == 'MA') {
        BookList = [
          'level1MA', //MA AS PAPER L1 == level1MA
          'cb2MA', //cb1MA
          'pb2MA'
        ];
      } else {
        BookList = [
          'level1AA', //MA AS PAPER L1 == level1MA
          'cb2AA', //cb1MA
          'pb2AA'
        ];
      }
    } else {
      int level = int.parse(currentlevel.value.split(' ')[1]) + 2;
      int paperLevel = int.parse(currentlevel.value.split(' ')[1]) + 1;
      int currentLevel = int.parse(currentlevel.value.split(' ')[1]);
      if(data.program == 'MA' && currentLevel == 5){
        BookList = [
          'level5MA',
          'cb6MA', //cb1MA
          'pb6MA'
        ];
      } else if(data.program == 'MA' && currentLevel == 6){
        BookList = [
          'level6MA', //MA AS PAPER L1 == level1MA
        ];
      }
      else{
        if (data.program == 'MA') {
          BookList = [
            'level${paperLevel}MA', //MA AS PAPER L1 == level1MA
            'cb${level}MA', //cb1MA
            'pb${level}MA'
          ];
        } else {
          if (kDebugMode) {
            print('AA program');
          }
          BookList = [
            'level${paperLevel}AA', //MA AS PAPER L1 == level1MA
            'cb${level}AA', //cb1MA
            'pb${level}AA'
          ];
        }
      }
    }
  }

  void updateOrder() {
    backendformat();
    isLoading.value = true;
    Map<String, dynamic>? requestData;
    if (gc.value == true) {
      gcstring.value = "Graduate Certificate";
      requestData = {
        "franchise": "${Prefs.getString(USERNAME)}",
        "studentID": "${data.studentID}",
        "futureLevel": "${futurelevel.value}",
        "currentLevel": "${currentlevel.value}",
        "items": BookList,
        "program": "${programText.text}",
        'certificate': '${gcstring.value}'
      };
    } else if (mc.value == true) {
      mcstring.value = "Master Certificate";
      if(currentlevel.value =='Level 5' && programText.text == 'AA'){
        requestData = {
          "franchise": "${Prefs.getString(USERNAME)}",
          "studentID": "${data.studentID}",
          "futureLevel": "${futurelevel.value}",
          "currentLevel": "${currentlevel.value}",
          "items": BookList,
          'enableBtn': disableBtn.value,
          "program": "${programText.text}",
          'certificate': '${mcstring.value}'
        };
      }else{
        requestData = {
          "franchise": "${Prefs.getString(USERNAME)}",
          "studentID": "${data.studentID}",
          "futureLevel": "${futurelevel.value}",
          "currentLevel": "${currentlevel.value}",
          "items": BookList,
          'enableBtn': false,
          "program": "${programText.text}",
          'certificate': '${mcstring.value}'
        };
      }
    } else {
      requestData = {
        "franchise": "${Prefs.getString(USERNAME)}",
        "studentID": "${data.studentID}",
        "futureLevel": "${futurelevel.value}",
        "currentLevel": "${currentlevel.value}",
        "items": BookList,
        'enableBtn': isChecked.value,
        "program": "${programText.text}",
        'certificate': ''
      };
    }
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
          Get.offAllNamed(ROUTE_HOME);
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
