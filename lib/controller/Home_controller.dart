import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../api/request.dart';
import '../api/url.dart';
import '../model/HomeModel.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var approvedfranchiselist = List<FMData>.empty(growable: true).obs;
  var nonapprovedfranchiselist = List<FMData>.empty(growable: true).obs;

  void onInit() {
    getFranchiseList();
    super.onInit();
  }

  void getFranchiseList() async {
    nonapprovedfranchiselist.clear();
    approvedfranchiselist.clear();
    isLoading.value = true;
    RequestDio request = RequestDio(url: getallfranchiseUrl);
    request.post().then((response) async {
      if (response.statusCode == 200) {
        FranchiseModel franchise = FranchiseModel.fromJson(response.data);
        if (franchise.status == true) {
          for (var element in franchise.data!) {
            {
              if (element.approve == true) {
                approvedfranchiselist.add(element);
                if (kDebugMode) {
                  print(approvedfranchiselist);
                }
              } else {
                if (element.approve == false) {
                  if (kDebugMode) {
                    print(element.franchiseID);
                  }
                }
                nonapprovedfranchiselist.add(element);
              }
            }
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
        FranchiseModel franchise = FranchiseModel.fromJson(response.data);
        if (franchise.status == true) {
          for (var element in franchise.data!) {
            {
              if (element.approve == true) {
                approvedfranchiselist.add(element);
                if (element.approve == true) {
                  if (kDebugMode) {
                    print('Approved ${element.franchiseID}');
                  }
                }
              } else {
                nonapprovedfranchiselist.add(element);
                if (element.approve == false) {
                  if (kDebugMode) {
                    print('Not Approved ${element.franchiseID}');
                  }
                }
              }
            }
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

  void approve(String ID) {
    isLoading.value = true;
    Map<String, dynamic> requestData = {
      "franchiseID": "$ID",
    };
    if (kDebugMode) {
      print(requestData);
    }
    RequestDio request = RequestDio(url: approveUserUrl, body: requestData);
    request.post().then((response) async {
      if (kDebugMode) {
        print(response.data);
      }
      if (response.statusCode == 200) {
        ApprovedModel approve =
            ApprovedModel.fromJson(jsonDecode(response.data));
        getFranchiseList();
        Fluttertoast.showToast(msg: approve.msg!);
        isLoading.value = false;
        update();
      } else {
        Get.snackbar("Info", "Status not 201",
            colorText: Colors.white,
            backgroundColor: Colors.blue,
            snackPosition: SnackPosition.TOP);
        isLoading.value = false;
      }
    }).onError((error, stackTrace) {
      Get.snackbar("Error", "$error",
          colorText: Colors.white,
          backgroundColor: Colors.blue,
          snackPosition: SnackPosition.TOP);
      isLoading.value = false;
      update();
    });
  }
}
