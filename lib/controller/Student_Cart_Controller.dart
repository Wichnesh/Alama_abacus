import 'dart:convert';

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
import 'Home_controller.dart';

class StudentCardListController extends GetxController {
  var isLoading = false.obs;
  var studentCardList = List<CSLData>.empty(growable: true).obs;
  List<dynamic> studentEnroll = [].obs;

  @override
  void onInit() {
    super.onInit();
    getCartStudentList();
  }

  void getCartStudentList() async {
    isLoading.value = true;
    Map<String, dynamic> requestData = {
      "username": Prefs.getString(USERNAME),
    };
    RequestDio request = RequestDio(url: getcartstudents, body: requestData);
    request.post().then((response) async {
      if (kDebugMode) {
        print(response.data);
      }
      if (response.statusCode == 200) {
        CartStudentList student = CartStudentList.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentCardList.add(element);
          }
          isLoading.value = false;
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else if (response.statusCode == 201) {
        CartStudentList student = CartStudentList.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentCardList.add(element);
          }
          isLoading.value = false;
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else {
        Get.snackbar("Error", "Fetching error",
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

  int updateTotalCost() {
    int total = 0;
    for (var student in studentCardList) {
      print(student.cost![0]);
      total += student.cost![0];
    }
    if (kDebugMode) {
      print(total);
    }
    return total;
  }

  void updatePaymentId(String paymentId) {
    for (var student in studentCardList) {
      student.paymentID = paymentId;
    }
    studentEnroll.add(studentCardList);
    enrollStudent();
    update();
  }

  void enrollStudent() async {
    isLoading.value = true;
    Map<String, dynamic> requestData = {
      "data": studentCardList,
    };
    if (kDebugMode) {
      print(requestData.toString());
    }
    RequestDio request =
        RequestDio(url: multiplestudentsUrl, body: requestData);
    request.post().then((response) async {
      if (kDebugMode) {
        print(response.data);
      }
      if (response.statusCode == 200) {
        registrationsuccessmodel success =
            registrationsuccessmodel.fromJson(response.data);
        if (success.status == true) {
          Fluttertoast.showToast(msg: success.message!);
          final HomeController homeController = Get.put(HomeController());
          homeController.studentList.clear();
          homeController.getFranchiseStudentList();
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
          final HomeController homeController = Get.find<HomeController>();
          homeController.studentList.clear();
          homeController.getFranchiseStudentList();
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
