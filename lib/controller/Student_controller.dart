import 'dart:convert';

import 'package:alama_eorder_app/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../api/request.dart';
import '../api/url.dart';
import '../model/registermodel.dart';
import '../utils/pref_manager.dart';
import 'Home_controller.dart';

class StudentController extends GetxController {
  TextEditingController nameText = TextEditingController();
  TextEditingController addressText = TextEditingController();
  TextEditingController mobileNoText = TextEditingController();
  TextEditingController cityText = TextEditingController();
  TextEditingController stateText = TextEditingController();
  TextEditingController countryText = TextEditingController();
  TextEditingController fatherText = TextEditingController();
  TextEditingController motherText = TextEditingController();
  TextEditingController enrollDateText = TextEditingController();
  TextEditingController emailText = TextEditingController();
  DateTime? enrollDate;
  var isLoading = false.obs;
  var level = "Select".obs;
  var paymentID = ''.obs;
  var orderID = ''.obs;
  var selectedState = "Tamil Nadu".obs;
  var selectedDistrict = "Chennai".obs;
  var levelList =
      ['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5', 'Level 6'].obs;

  void onInit() {
    super.onInit();
    generateStudentId();
  }

  final stateData = [
    "USA",
    "Tamil Nadu",
    "Karnataka",
    "Telangana",
    "Madhya pradesh",
    "Maharashtra",
    "New Delhi",
    "Pondicherry",
    "Gujarat",
    "Goa",
    "Andhra pradesh",
    "Chandigarh"
  ];
  final districtData = {
    "Tamil Nadu": [
      "Ariyalur",
      "Chengalpattu",
      "Chennai",
      "Coimbatore",
      "Cuddalore",
      "Dharmapuri",
      "Dindigul",
      "Erode",
      "Kallakurichi",
      "Kancheepuram",
      "Karur",
      "Krishnagiri",
      "Madurai",
      "Mayiladuthurai",
      "Nagapattinam",
      "Kanniyakumari",
      "Namakkal",
      "Perambalur",
      "Pudukottai",
      "Ramanathapuram",
      "Ranipet",
      "Salem",
      "Sivagangai",
      "Tenkasi",
      "Thanjavur",
      "Theni",
      "Thiruvallur",
      "Thiruvarur",
      "Thoothukudi",
      "Trichirappalli",
      "Tirupathur",
      "Tiruppur",
      "Tiruvannamalai",
      "The Nilgiris",
      "Vellore",
      "Viluppuram",
      "Virudhunagar",
    ],
    "Telangana": [
      "ADILABAD",
      "BHADRADRI KOTHAGUDEM",
      "HANUMAKONDA",
      "HYDERABAD",
      "	JAGTIAL",
      "JANGOAN",
      "JAYASHANKAR BHOOPALPALLY",
      "JOGULAMBA GADWAL",
      "KAMAREDDY",
      "KHAMMAM",
      "	KOMARAM BHEEM ASIFABAD",
      "MAHABUBABAD",
      "MAHABUBNAGAR",
      "MANCHERIAL",
      "MEDAK",
      "	MEDCHAL-MALKAJGIRI",
      "	NAGARKURNOOL",
      "NALGONDA",
      "	NARAYANPET",
      "NIRMAL",
      "	NIZAMABAD",
      "PEDDAPALLI",
      "RAJANNA SIRCILLA",
      "RANGAREDDY",
      "	SANGAREDDY",
      "SIDDIPET",
      "SURYAPET",
      "VIKARABAD",
      "WANAPARTHY",
      "	WARANGAL",
      "YADADRI BHUVANAGIRI",
    ],
    "Karnataka": ["Bengaluru"],
    "Madhya pradesh": ["Bhopal", "Shivpuri"],
    "Maharashtra": ["Mumbai"],
    "New Delhi": ["New Delhi"],
    "Pondicherry": ["karaikal"],
    "Gujarat": ["Surat"],
    "Andhra pradesh": [
      "Guntur",
      "Kadapa",
      "kunchanapalli",
      "Shreekakulam",
      "Tirupathi",
      "Vijaywada",
      "Vishakapatnam"
    ],
    "Chandigarh": ["chandigarh"],
    "USA": ["Columbia", "Michigan", "New jersey"],
  };

  void updateSelectedState(newValue) {
    selectedState.value = newValue;
    selectedDistrict.value = districtData[newValue]![
        0]; // Initialize with the first district in the selected state.
    update();
  }

  void updatelevel(String value) {
    level.value = value;
    update();
  }

  var program = "Select".obs;
  var programList = ['MA', 'AA'].obs;

  void updateProgramList(String value) {
    program.value = value;
  }

  List<String> selectedItems = [];
  var pencil = false.obs;
  var bag = false.obs;
  var studentAbacus = false.obs;
  var listeningAbility = false.obs;
  var progressCard = false.obs;

  void setPencil(bool value) {
    pencil.value = value;
  }

  void setBag(bool value) {
    bag.value = value;
  }

  void setStudentAbacus(bool value) {
    studentAbacus.value = value;
  }

  void setListeningAbility(bool value) {
    listeningAbility.value = value;
  }

  void setProgressCard(bool value) {
    progressCard.value = value;
  }

  List<String> getSelectedItems() {
    if (pencil.value) {
      selectedItems.add('pencil');
    }
    if (bag.value) {
      selectedItems.add('bag');
    }
    if (studentAbacus.value) {
      selectedItems.add('studentAbacus');
    }
    if (listeningAbility.value) {
      selectedItems.add('listeningAbility');
    }
    if (progressCard.value) {
      selectedItems.add('progressCard');
    }
    if (kDebugMode) {
      print(selectedItems);
    }
    return selectedItems;
  }

  List<int> costList = [];
  var admission = true.obs;
  var levelCost = false.obs;

  void setAdmission(bool value) {
    admission.value = value;
  }

  void setLevelCost(bool value) {
    levelCost.value = value;
  }

  List<int> getCostList() {
    if (admission.value) {
      costList.add(1300);
    }
    if (levelCost.value) {
      costList.add(500);
    }

    return costList;
  }

  var isChecked = false.obs;
  var selectedShirt = 'Select'.obs;
  var tShirtSize = ['8', '12', '16'].obs;

  void updateTShirt(String value) {
    selectedShirt.value = value;
  }

  void toggleCheckbox(bool newValue) {
    isChecked.value = newValue;
    if (!newValue) {
      selectedShirt.value =
          ''; // Clear the selection if the checkbox is unchecked.
    }
  }

  var Id = ''.obs;
  void generateStudentId() {
    isLoading.value = true;
    RequestDio request = RequestDio(url: generateStudentIDUrl);
    request.post().then((response) async {
      registermodel data = registermodel.fromJson(jsonDecode(response.data));
      try {
        if (data.status == true) {
          Id.value = data.data!;
          Fluttertoast.showToast(msg: "Student Id generated");
          isLoading.value = false;
          update();
        } else {
          Fluttertoast.showToast(msg: "Student Id not generated");
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

  var totalAmount = ''.obs;

  void submit() {
    isLoading.value = true;
    getSelectedItems();
    getCostList();
    if (selectedShirt.value == '') {
      selectedShirt.value = '0';
    }
    if (selectedShirt.value == 'Select') {
      selectedShirt.value = '0';
    }
    Map<String, dynamic> requestData = {
      "studentID": '${Id.value}',
      "enrollDate": '${enrollDateText.text}',
      "studentName": "${nameText.text}",
      "address": "${addressText.text}",
      "state": "${selectedState.value}",
      "district": "${selectedDistrict.value}",
      "mobileNumber": "${mobileNoText.text}",
      "email": "${emailText.text}",
      "fatherName": "${fatherText.text}",
      "motherName": "${motherText.text}",
      "franchise": "${Prefs.getString(USERNAME)}",
      "level": "${level.value}",
      "items": selectedItems,
      "tShirt": '${selectedShirt.value}',
      "program": '${program.value}',
      "cost": costList,
      "paymentID": "${paymentID.value}"
    };
    if (kDebugMode) {
      print(requestData);
    }
    RequestDio request =
        RequestDio(url: studentregistrationUrl, body: requestData);
    request.post().then((response) async {
      if (kDebugMode) {
        print(response.data);
      }
      if (response.statusCode == 200) {
        registrationsuccessmodel success =
            registrationsuccessmodel.fromJson(response.data);
        if (success.status == true) {
          Fluttertoast.showToast(msg: success.message!);
          final HomeController homeController = Get.find<HomeController>();
          homeController.getStudentList();
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
          final HomeController homeController = Get.find<HomeController>();
          homeController.studentList.clear();
          homeController.getStudentList();
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
