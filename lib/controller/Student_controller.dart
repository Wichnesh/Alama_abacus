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
import '../model/studentmodel.dart';
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
  var selectedState = "Telangana".obs;
  var selectedDistrict = "HYDERABAD".obs;
  var levelList = ['Enroll','Pre Level'].obs;
  var costBool = true.obs;
  var enrollValue = '1300'.obs;
  var programValue = ''.obs;

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
    "West Bengal",
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
      "JAGTIAL",
      "JANGOAN",
      "JAYASHANKAR BHOOPALPALLY",
      "JOGULAMBA GADWAL",
      "KAMAREDDY",
      "KHAMMAM",
      "KOMARAM BHEEM ASIFABAD",
      "MAHABUBABAD",
      "MAHABUBNAGAR",
      "MANCHERIAL",
      "MEDAK",
      "MEDCHAL-MALKAJGIRI",
      "NAGARKURNOOL",
      "NALGONDA",
      "NARAYANPET",
      "NIRMAL",
      "NIZAMABAD",
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
      "SECUNDERABAD"
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
    "West Bengal":["Kolkata"],
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

  void costBoolUpdate(String state){
    if(costBool.value == true){
     if(level.value == 'Pre Level' && state == 'Tamil Nadu'){
       enrollValue.value = '1700';
     }else if(level.value == 'Enroll' && state == 'Tamil Nadu'){
       enrollValue.value = '1100';
     }else if(level.value=='Select' && state == 'Tamil Nadu'){
       enrollValue.value = '1100';
     }
     else if(level.value =='Pre Level' ){
       enrollValue.value = '2000';
     } else {
       enrollValue.value = '1300';
     }
    }else{
      if(level.value == 'Pre Level'){
        enrollValue.value = '2000';
      }else{
        enrollValue.value = '1300';
      }
    }
  }
  var programBool = false.obs;
  void programBoolUpdate(){
    if(program.value == 'MA'){
      programValue.value = program.value;
    }else{
      programValue.value = program.value;
    }
    update();
  }

  var program = "Select".obs;
  String? selectedProgram ;
  var programList = [].obs;

  void updateProgramList(String value) {
    program.value = value;
    selectedProgram = value;
  }

  List<dynamic> selectedItems = [].obs;
  var pencil = true.obs;
  var bag = true.obs;
  var studentAbacus = true.obs;
  var listeningAbility = true.obs;
  var progressCard = true.obs;
  var speedWritingBook = true.obs;
  var cb1Book = true.obs;
  var pb1Book = true.obs;
  var preLevel1 = false.obs;
  var preLevel2 = false.obs;
  var enablePreLevelCheckBox = false.obs;

  void preLevelCheckBox(){
    programList.clear();
    selectedProgram = null;
    if(level.value == 'Pre Level'){
      enablePreLevelCheckBox.value = true;
      preLevel1.value = true;
      preLevel2.value = true;
      program.value = 'Select';
      programList.value = ['AA'];
    }else{
      enablePreLevelCheckBox.value = false;
      preLevel1.value = false;
      preLevel2.value = false;
      program.value = 'Select';
      programList.value = ['MA', 'AA'];
    }
    update();
  }

  void setPreLevel(bool value){
    preLevel1.value = value;
    preLevel2.value = value;
  }

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

  void setSpeedWritingBook(bool value){
    speedWritingBook.value = value;
  }

  void setCb1Book(bool value){
    cb1Book.value = value;
  }

  void setPd1Book(bool value){
    pb1Book.value = value;
  }

  List<dynamic>? getSelectedItems() {
    selectedItems.clear();
    if (pencil.value) {
      selectedItems.add('pencil');
    }
    if (bag.value) {
      selectedItems.add('studentBag');
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
    if (speedWritingBook.value){
      selectedItems.add('speedWritingBook');
    }
    if(cb1Book.value){
      selectedItems.add('cb1${programValue.value}');
    }
    if(pb1Book.value){
      selectedItems.add('pb1${programValue.value}');
    }
    if(preLevel1.value){
      selectedItems.add('preLevel1');
    }
    if(preLevel2.value){
      selectedItems.add('preLevel2');
    }
    return selectedItems;
  }

  List<dynamic> costList = [].obs;
  var admission = true.obs;
  var levelCost = false.obs;

  void setAdmission(bool value) {
    admission.value = value;
  }

  void setLevelCost(bool value) {
    levelCost.value = value;
  }

  List<dynamic> getCostList() {
    if (admission.value) {
      costList.add(enrollValue.value);
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
      selectedShirt.value = ''; // Clear the selection if the checkbox is unchecked.
    }
  }

  var Id = ''.obs;

  void generateStudentId() {
    isLoading.value = true;
    Map<String, dynamic> requestData = {
      "username": Prefs.getString(USERNAME),
    };
    RequestDio request = RequestDio(url: generateStudentIDUrl,body: requestData);
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
    Map<String, dynamic> requestData = {
      "studentID": Id.value,
      "enrollDate": enrollDateText.text,
      "studentName": nameText.text,
      "address": addressText.text,
      "state": selectedState.value,
      "district": selectedDistrict.value,
      "mobileNumber": mobileNoText.text,
      "email": emailText.text,
      "fatherName": fatherText.text,
      "motherName": motherText.text,
      "franchise": Prefs.getString(USERNAME),
      "level": level.value,
      "items": selectedItems,
      "tShirt": selectedShirt.value,
      "program": program.value,
      "cost": costList,
      "paymentID": paymentID.value
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
          homeController.studentList.clear();
          homeController.getFranchiseStudentList();
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
          homeController.getFranchiseStudentList();
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


  void addUnpaidStudent() {
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
      "studentID": Id.value,
      "enrollDate": enrollDateText.text,
      "studentName": nameText.text,
      "address": addressText.text ?? "NA" ,
      "state": selectedState.value,
      "district": selectedDistrict.value,
      "mobileNumber": mobileNoText.text,
      "email": emailText.text,
      "fatherName": fatherText.text ?? "NA",
      "motherName": motherText.text ?? "NA",
      "franchise": Prefs.getString(USERNAME),
      "level": level.value,
      "items": selectedItems,
      "tShirt": selectedShirt.value,
      "program": program.value,
      "cost": costList,
      "paymentID": paymentID.value
    };
    if (kDebugMode) {
      print(requestData);
    }
    RequestDio request =
    RequestDio(url: studentcartregUrl, body: requestData);
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
          dispose();
          Get.offAllNamed(ROUTE_STUDENTCARTLISTSCREEN);
        } else {
          Fluttertoast.showToast(msg: success.message!);
          isLoading.value = false;
          Get.offAllNamed(ROUTE_STUDENTCARTLISTSCREEN);
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
