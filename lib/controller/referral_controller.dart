import 'dart:developer';

import 'package:alama_eorder_app/api/request.dart';
import 'package:alama_eorder_app/api/url.dart';
import 'package:alama_eorder_app/model/HomeModel.dart';
import 'package:alama_eorder_app/model/get_refferal_model.dart';
import 'package:alama_eorder_app/model/get_refferal_status_model.dart';
import 'package:alama_eorder_app/utils/constant.dart';
import 'package:alama_eorder_app/utils/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReferralController extends GetxController {
  final franchiseIdController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  var isLoading = false.obs;
  RxInt loadingIndex = (-1).obs;
  var referralModel = GetRefferalModel().obs;
  var statusModel = Rxn<StatusModel>();
  var selectedStatusTab = 0.obs;
  Rx<FMData?> selectedFranchise = Rx<FMData?>(null);

  List<Datum> get referrals => referralModel.value.data ?? [];

  int get totalCount => referralModel.value.count ?? 0;

  var selectedList = <Map<String, String>>[].obs;

  bool get isAllSelected =>
      selectedList.length == referrals.length && referrals.isNotEmpty;

  List<All> get filteredStatusList {
    final list = statusModel.value?.data?.all ?? [];

    return list.where((e) {
      final status = (e.status ?? "").toLowerCase().trim();

      switch (selectedStatusTab.value) {
        case 0: // Link Sent
          return status.isEmpty || status == "link sent";

        case 1: // Interested
          return status == "interested";

        case 2: // Free Enrolled
          return status == "enrolledforfreeprogram";

        case 3: // Not Interested
          return status == "not interested";

        case 4: // ✅ Paid Enrolled
          return status == "enrolledforpaidprogram";

        default:
          return true;
      }
    }).toList();
  }

  List<Datum> get pendingReferrals {
    return referrals.where((e) => e.isLinkSent != true).toList();
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
    await refferalResponse();
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

  Future<void> enrollForFreeProgram(All item) async {
    try {
      isLoading.value = true;

      final data = {
        "leadIds": [item.id],
      };

      RequestDio request = RequestDio(url: enrollStudentUrl, body: data);

      final response = await request.post();

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Enroll Response: ${response.data}");
        Fluttertoast.showToast(msg: "Leads enrolled successfully");
        clearSelection();
        await refreshList();
      } else {
        Get.snackbar(
          'Error',
          'Failed to enroll leads: ${response.statusMessage}',
          snackPosition: SnackPosition.BOTTOM,
        );
        log("Error response: ${response.data}");
        log("Status code: ${response.statusCode}");
        log("Status message: ${response.statusMessage}");
        log("Request data: $data");
        log("Request URL: ${request.url}");
      }
    } catch (e) {
      log("Exception: $e");
      Get.snackbar(
        'Error',
        'Failed to enroll leads: $e',
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

  Future<void> createLink(int index) async {
    try {
      loadingIndex.value = index;

      final data = [
        {
          "name": referrals[index].name ?? "",
          "phone": referrals[index].phoneNumber ?? "",
          "franchiseName": referrals[index].franchiseId ?? "",
        }
      ];

      RequestDio request = RequestDio(
        url: createLinkUrl,
        body: data,
      );

      final response = await request.post();

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Create Link Response: ${response.data}");

        /// 🔥 RESPONSE LIST
        final List resList = response.data;

        if (resList.isNotEmpty) {
          final phone = resList[0]["phone"] ?? "";
          final link = resList[0]["link"] ?? "";

          await sendWhatsApp(phone, link);
        }

        clearSelection();
        await refreshList();
      } else {
        Get.snackbar(
          'Error',
          'Failed to create links: ${response.statusMessage}',
          snackPosition: SnackPosition.BOTTOM,
        );

        log("Error response: ${response.data}");
        log("Status code: ${response.statusCode}");
        log("Status message: ${response.statusMessage}");
        log("Request data: $data");
        log("Request URL: ${request.url}");
      }
    } catch (e) {
      log("Exception: $e");

      Get.snackbar(
        'Error',
        'Failed to create links: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      loadingIndex.value = -1;
    }
  }

  Future<void> sendWhatsApp(String phone, String link) async {
    /// Clean number
    phone = phone.replaceAll(RegExp(r'\D'), '');

    /// Add India code
    if (!phone.startsWith("91")) {
      phone = "91$phone";
    }

    final message = Uri.encodeComponent(
      "Hi,From alama Abacus please check your link: $link",
    );

    final url = Uri.parse("https://wa.me/$phone?text=$message");

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar("Error", "Could not open WhatsApp");
    }
  }

  Future assignToFranchise(String leadId, String franchiseId) async {
    try {
      isLoading.value = true;

      final data = {
        "leadId": leadId,
        "assignToFranchiseID": franchiseId,
      };

      RequestDio request = RequestDio(url: assignToFranchiseUrl, body: data);

      final response = await request.post();

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Assign Response: ${response.data}");
        Fluttertoast.showToast(msg: "Lead assigned successfully");
        clearSelection();
        await refreshList();
      } else {
        Get.snackbar(
          'Error',
          'Failed to assign lead: ${response.statusMessage}',
          snackPosition: SnackPosition.BOTTOM,
        );
        log("Error response: ${response.data}");
        log("Status code: ${response.statusCode}");
        log("Status message: ${response.statusMessage}");
        log("Request data: $data");
        log("Request URL: ${request.url}");
      }
    } catch (e) {
      log("Exception: $e");
      Get.snackbar(
        'Error',
        'Failed to assign lead: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
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
