import 'dart:developer';

import 'package:alama_eorder_app/api/request.dart';
import 'package:alama_eorder_app/api/url.dart';
import 'package:alama_eorder_app/model/get_refferal_model.dart';
import 'package:alama_eorder_app/model/get_refferal_status_model.dart';
import 'package:alama_eorder_app/utils/constant.dart';
import 'package:alama_eorder_app/utils/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ReferralController extends GetxController {
  final franchiseIdController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  var isLoading = false.obs;
  var referralModel = GetRefferalModel().obs;
  var statusModel = Rxn<StatusModel>();
  var selectedTab = 0.obs;

  List<Datum> get referrals => referralModel.value.data ?? [];

  int get totalCount => referralModel.value.count ?? 0;

  var selectedList = <Map<String, String>>[].obs;

  bool get isAllSelected =>
      selectedList.length == referrals.length && referrals.isNotEmpty;

  List get currentList {
    if (statusModel.value == null) return [];

    switch (selectedTab.value) {
      case 1:
        return statusModel.value!.interested;

      case 2:
        return statusModel.value!.notInterested;

      default:
        return statusModel.value!.all;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    franchiseIdController.text = Prefs.getString(franchiseId);
    log("Franchise ID: ${franchiseIdController.text}");
    await fetchReferrals();
    await refferalResponse();
  }

  String? validateFranchiseId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Franchise ID is required';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'Enter valid 10-digit phone number';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  /// toggle single selection
  void toggleSelection(Datum item) {
    final exists = selectedList.any((e) => e["phone"] == item.phoneNumber);

    if (exists) {
      selectedList.removeWhere((e) => e["phone"] == item.phoneNumber);
    } else {
      selectedList.add({
        "name": item.name ?? "",
        "phone": item.phoneNumber ?? "",
        "franchiseName": item.franchiseId ?? "",
      });
    }
  }

  /// select all
  void selectAll() {
    selectedList.value = referrals.map((item) {
      return {
        "name": item.name ?? "",
        "phone": item.phoneNumber ?? "",
        "franchiseName": item.franchiseId ?? "",
      };
    }).toList();
  }

  /// clear all
  void clearSelection() {
    selectedList.clear();
  }

  Future fetchReferrals() async {
    try {
      isLoading.value = true;

      RequestDio request = RequestDio(
        url: getFranchiseRefferal.replaceFirst(
          "{franchiseId}",
          franchiseIdController.text.trim(),
        ),
      );

      final response = await request.get();

      if (response.statusCode == 200 || response.statusCode == 201) {
        referralModel.value = GetRefferalModel.fromJson(response.data);

        log("Referral List Response: ${response.data}");
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch referrals: ${response.statusMessage}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch referrals: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshList() async {
    await fetchReferrals();
  }

  Future<void> refferalResponse() async {
    try {
      isLoading.value = true;

      RequestDio request = RequestDio(
        url: getRefferalResponseUrl.replaceFirst(
          "{franchiseId}",
          franchiseIdController.text.trim(),
        ),
      );

      final response = await request.get();

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Referral Response: ${response.data}");
        Fluttertoast.showToast(msg: "Referral responses fetched successfully");
        statusModel.value = StatusModel.fromJson(response.data);
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch referral responses: ${response.statusMessage}',
          snackPosition: SnackPosition.BOTTOM,
        );
        log("Error response: ${response.data}");
        log("Status code: ${response.statusCode}");
        log("Status message: ${response.statusMessage}");
        log("Request URL: ${request.url}");
      }
    } catch (e) {
      log("Exception: $e");
      Get.snackbar(
        'Error',
        'Failed to fetch referral responses: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitForm() async {
    try {
      isLoading.value = true;
      final data = {
        "franchiseID": franchiseIdController.text.trim(),
        "phoneNumber": phoneController.text.trim(),
        "name": nameController.text.trim(),
      };

      RequestDio request = RequestDio(url: addPhoneUrl, body: data);

      request.post().then((response) async {
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Referral added successfully");
          Get.back();
          await fetchReferrals();
          clearForm();
        } else {
          Get.snackbar(
              'Error', 'Failed to submit referral: ${response.statusMessage}',
              snackPosition: SnackPosition.BOTTOM);
          log("Error response: ${response.data}");
          log("Status code: ${response.statusCode}");
          log("Status message: ${response.statusMessage}");
          log("Request data: $data");
          log("Request URL: ${request.url}");
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit referral: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  clearForm() {
    phoneController.clear();
    nameController.clear();
  }

  @override
  void onClose() {
    franchiseIdController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
