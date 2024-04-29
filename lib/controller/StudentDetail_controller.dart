import 'package:alama_eorder_app/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/request.dart';
import '../api/url.dart';
import '../model/studentmodel.dart';

class StudentDetailController extends GetxController {

  var isLoading = false.obs;
  late SData? studentDetail;

  void onInit() {
    super.onInit();
    getStudentDetail();
  }


  void getStudentDetail() async {
    isLoading.value = true;
    if (kDebugMode) {
      print(getallstudentsUrl);
    }
    var body = {
      "studentID"  : AppConstant.studentID
    };
    RequestDio request = RequestDio(url: getallstudentsUrl,parameters: body);
    request.post().then((response) async {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.data);
      }
      if (response.statusCode == 200) {
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentDetail = element;
          }

          isLoading.value = false;
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      }else {
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
      print(error);
      isLoading.value = false;
    });
    update();
  }
}
