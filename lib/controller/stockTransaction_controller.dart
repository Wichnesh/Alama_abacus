import 'package:alama_eorder_app/model/stockmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/request.dart';
import '../api/url.dart';

class StockTransactionController extends GetxController {
  var isLoading = false.obs;
  var transaction = List<STRData>.empty(growable: true).obs;

  @override
  void onInit() {
    super.onInit();
  }

  void getTransaction(String name) {
    transaction.clear();
    isLoading.value = true;
    Map<String, dynamic> requestData = {
      "name": "${name}",
    };
    if (kDebugMode) {
      print(getitemtransactionUrl);
    }
    RequestDio request =
        RequestDio(url: getitemtransactionUrl, body: requestData);
    request.post().then((response) async {
      if (response.statusCode == 200) {
        TransactionModel stock = TransactionModel.fromJson(response.data);
        if (stock.status == true) {
          for (var element in stock.data!) {
            transaction.add(element);
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
        TransactionModel student = TransactionModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            transaction.add(element);
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
}
