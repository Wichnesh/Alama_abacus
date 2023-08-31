import 'dart:convert';

import 'package:alama_eorder_app/api/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../api/request.dart';
import '../model/registermodel.dart';

class RegisterController extends GetxController {
  TextEditingController generateId = TextEditingController();
  TextEditingController nametext = TextEditingController();
  TextEditingController emailtext = TextEditingController();
  TextEditingController contactNo = TextEditingController();
  TextEditingController stateText = TextEditingController();
  TextEditingController countryText = TextEditingController();
  TextEditingController usernameText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController confirmPasswordText = TextEditingController();
  TextEditingController registerDateText = TextEditingController();
  DateTime? date;
  var Id = "".obs;
  var isLoading = true.obs;

  void onInit() {
    generateFID();
    super.onInit();
  }

  void generateFID() async {
    isLoading.value = true;
    RequestDio request = RequestDio(url: generateIDUrl);
    request.post().then((response) async {
      registermodel data = registermodel.fromJson(jsonDecode(response.data));
      try {
        if (data.status == true) {
          Id.value = data.data!;
          Fluttertoast.showToast(msg: "Franchise Id generated");
          isLoading.value = false;
          update();
        } else {
          Fluttertoast.showToast(msg: "Franchise Id not generated");
          isLoading.value = false;
          update();
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }).onError((error, stackTrace) {
      Get.snackbar("Error", "$error",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
      isLoading.value = false;
    });
    update();
  }

  void submit() {
    if (countryText.text.isEmpty ||
        stateText.text.isEmpty ||
        nametext.text.isEmpty ||
        passwordText.text.isEmpty ||
        usernameText.text.isEmpty ||
        contactNo.text.isEmpty ||
        confirmPasswordText.text.isEmpty) {
      Get.snackbar("Error", "please enter all the field",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
    } else {
      isLoading.value = true;
      Map<String, dynamic> requestData = {
        "franchiseID": "${Id.value}",
        "name": "${nametext.text}",
        "email": "${emailtext.text}",
        "contactNumber": "${contactNo.text}",
        "state": "${stateText.text}",
        "country": "${countryText.text}",
        "username": "${usernameText.text}",
        "password": "${passwordText.text}",
        "registerDate": "${registerDateText.text}"
      };
      if (kDebugMode) {
        print(requestData);
      }
      RequestDio request = RequestDio(url: regfrachaniseUrl, body: requestData);
      request.post().then((response) async {
        if (kDebugMode) {
          print(response.data);
        }
        if (response.statusCode == 200) {
          registrationsuccessmodel success =
              registrationsuccessmodel.fromJson(jsonDecode(response.data));
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
      }).onError((error, stackTrace) {
        Get.snackbar("Error", "$error",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP);
        isLoading.value = false;
      });
      update();
    }
  }
}
