import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../api/request.dart';
import '../api/url.dart';
import '../model/HomeModel.dart';
import '../model/registermodel.dart';
import '../model/stockmodel.dart';
import '../model/studentmodel.dart';
import '../utils/constant.dart';
import '../utils/pref_manager.dart';
import '../view/Home/TabScreen/filterStudentScreen.dart';
import '../view/Home/TabScreen/filterfranchiseScreen.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var approvedfranchiselist = List<FMData>.empty(growable: true).obs;
  var nonapprovedfranchiselist = List<FMData>.empty(growable: true).obs;
  var studentList = List<SData>.empty(growable: true).obs;
  var stockList = List<StData>.empty(growable: true).obs;
  var filterStockList =List<STRData>.empty(growable: true).obs;
  var count = ''.obs;
  TextEditingController fromdateText = TextEditingController();
  TextEditingController todateText = TextEditingController();
  TextEditingController nametext = TextEditingController();
  TextEditingController contactNo = TextEditingController();
  DateTime? fromdate;
  DateTime? todate;
  var selectedState = "Select".obs;
  var selectedDistrict = "Select".obs;
  var selectedFranchise  ="Select".obs;
  var selectedLevel = "Select".obs;
  var selectedCountry = "".obs;
  var levelList = ['Enroll','Level 1','Level 2','Level 3','Level 4','Level 5','Level 6'].obs;

  final stateData = [
    "Select",
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
    "Chandigarh",
    "Abu Dhabi",
    "Australia",
    "Canada",
    "Dubai",
    "Europe",
    "Germany",
    "Jubail",
    "Netherlands",
    "Oman",
    "Scotland",
    "Uk",
    "South Korea",
    "Singapore"
  ];
  final districtData = {
    "Select" : ["Select"],
    "Tamil Nadu": [
      "Select",
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
      "Select",
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
      "SANGAREDDY",
      "SIDDIPET",
      "SURYAPET",
      "VIKARABAD",
      "WANAPARTHY",
      "WARANGAL",
      "YADADRI BHUVANAGIRI",
    ],
    "Karnataka": ["Select","Bengaluru"],
    "Madhya pradesh": ["Select","Bhopal", "Shivpuri"],
    "Maharashtra": ["Select","Mumbai"],
    "New Delhi": ["Select","New Delhi"],
    "Pondicherry": ["Select","karaikal"],
    "Gujarat": ["Select","Surat"],
    "Andhra pradesh": [
      "Select",
      "Guntur",
      "Kadapa",
      "kunchanapalli",
      "Shreekakulam",
      "Tirupathi",
      "Vijaywada",
      "Vishakapatnam"
    ],
    "Chandigarh": ["Select","chandigarh"],
    "USA": ["Select","Columbia", "Michigan", "New jersey"],
    "Abu Dhabi": ["Select","Abu Dhabi"],
    "Australia": ["Select","Australia"],
    "Canada": ["Select","Canada"],
    "Dubai": ["Select","Dubai"],
    "Europe": ["Select","Europe"],
    "Germany": ["Select","Germany"],
    "Jubail": ["Select","Jubail"],
    "Netherlands": ["Select","Netherlands"],
    "Oman": ["Select","Oman"],
    "Scotland": ["Select","Scotland"],
    "Uk": ["Select","london", "Uk"],
    "Goa" :["Select","Goa"],
    "South Korea" : ["Select","South Korea"],
    "Singapore" :["Select","Singapore"]
  };

  void updateSelectedState(String newValue) {
    selectedState.value = newValue;
    selectedDistrict.value = districtData[newValue]![
    0]; // Initialize with the first district in the selected state.
    update();
  }

  void updateSelectedFranchise(String newValue) {
    selectedFranchise.value = newValue;
  }

  void updateSelectedLevel(String newValue) {
    selectedLevel.value = newValue;
  }

  @override
  void onInit() {
    bool admin = Prefs.getBoolen(SHARED_ADMIN);
    getFranchiseList();
    admin ? stockIsLoading.value ? Container() : getStockList() : Container();
    admin ? getStudentList() : getFranchiseStudentList();
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

  void StockFilterlistmethod() {
    isLoading.value = true;
    update();
    Map<String, dynamic>? requestData;
    requestData = {
      "startDate": "${fromdateText.text}",
      "endDate": "${todateText.text}",
    };
    RequestDio request = RequestDio(url: getFilterTransactionUrl, body: requestData);
    if (kDebugMode) {
      print(requestData);
    }
    request.post().then((response) async {
      if (kDebugMode) {
        print(response.data);
        print(response.statusCode);
      }
      if (response.statusCode == 200) {
        TransactionModel stock = TransactionModel.fromJson(response.data);
        if (stock.status == true) {
          for (var element in stock.data!) {
            filterStockList.add(element);
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
        TransactionModel stock = TransactionModel.fromJson(response.data);
        if (stock.status == true) {
          for (var element in stock.data!) {
            filterStockList.add(element);
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
    });
  }

  void getStudentList() async {
    isLoading.value = true;
    if (kDebugMode) {
      print(getallstudentsUrl);
    }
    RequestDio request = RequestDio(url: getallstudentsUrl);
    request.post().then((response) async {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.data);
      }
      if (response.statusCode == 200) {
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentList.add(element);
          }
          debugPrint("total number of Students : ${studentList.length}");
          isLoading.value = false;
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else if (response.statusCode == 201) {
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentList.add(element);
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
      print(error);
      isLoading.value = false;
    });
    update();
  }


  void filterStudentList() async {
    isLoading.value = true;
    Map<String, dynamic>? params;
    if(selectedState.value == 'Select' && selectedDistrict.value == 'Select' && nametext.text.isEmpty && contactNo.text.isEmpty){
      if (kDebugMode) {
        print('nothing is selected');
      }
      return ;
    }else if(nametext.text.isEmpty && contactNo.text.isEmpty &&selectedState.value != 'Select' && selectedDistrict.value != 'Select' ){
      params = {
        'state': '${selectedState.value}',
        'district': '${selectedDistrict.value}',
      };
    }else if(nametext.text.isNotEmpty && contactNo.text.isNotEmpty && selectedState.value == 'Select' && selectedDistrict.value == 'Select'){
      params = {
        'name': '${nametext.text}',
        'phoneNumber': '${contactNo.text}',
      };
    }else if(selectedState.value != 'Select' && selectedDistrict.value != 'Select'){
      params = {
        'state': '${selectedState.value}',
        'district': '${selectedDistrict.value}',
      };
    }else if(nametext.text.isNotEmpty && contactNo.text.isNotEmpty && selectedState.value != 'Select' && selectedDistrict.value != 'Select'){
       params = {
        'name': '${nametext.text}',
        'state': '${selectedState.value}',
        'district': '${selectedDistrict.value}',
        'phoneNumber': '${contactNo.text}',
      };
    }else if(nametext.text.isNotEmpty && contactNo.text.isEmpty && selectedState.value == 'Select' && selectedDistrict.value == 'Select'){
      params = {
        'name': '${nametext.text}',
      };
    }else{
      // params = {
      //   'name': '${nametext.text}',
      //   'state': '${selectedState.value}',
      //   'district': '${selectedDistrict.value}',
      //   'phoneNumber': '${contactNo.text}',
      // };
    }
    if (kDebugMode) {
      print(getallstudentsUrl);
    }

    RequestDio request = RequestDio(url: '${getallstudentsUrl}',parameters: params);
    request.post().then((response) async {
      print('${response.data}');
      if (response.statusCode == 200) {
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentList.add(element);
          }
          print(studentList.length);
          isLoading.value = false;
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else if (response.statusCode == 201) {
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentList.add(element);
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

  void filterStudentListByName(String name) {
    // Create a new list to store the filtered results
    List<SData> filteredList = [];

    // Iterate over the original studentList
    for (var student in studentList) {
      // Check if the studentName contains the input name (case insensitive)
      if (student.studentName?.toLowerCase().contains(name.toLowerCase()) ?? false) {
        // If it matches, add it to the filtered list
        filteredList.add(student);
      }
    }
    Get.to(() => FilterStudentScreen(filteredList));
  }

  void filterStudentListAll(
      String name, String phoneNumber,String level ,String state, String district) {
    // Create a new list to store the filtered results
    List<SData> filteredList = [];

    // Iterate over the original studentList
    for (var student in studentList) {
      bool nameMatched = false;
      bool phoneMatched = false;
      bool stateMatched = false;
      bool districtMatched = false;
      bool levelMatched = false;

      // Check if the studentName contains the input name (case insensitive)
      if (name.isNotEmpty) {
        nameMatched = student.studentName?.toLowerCase().contains(name.toLowerCase()) ?? false;
      }

      // Check if the mobileNumber contains the input phoneNumber
      if (phoneNumber.isNotEmpty) {
        phoneMatched = student.mobileNumber?.contains(phoneNumber) ?? false;
      }
      if(level != "Select"){
        levelMatched = student.level?.contains(level) ?? false;
      }
      // Check if the state contains the input state (case insensitive)
      if (state != 'Select') {
        stateMatched = student.state?.toLowerCase().contains(state.toLowerCase()) ?? false;
      }

      // Check if the district contains the input district (case insensitive)
      if (district != 'Select') {
        districtMatched = student.district?.toLowerCase().contains(district.toLowerCase()) ?? false;
      }

      // If any of the conditions are met, add it to the filtered list
      if(name.isNotEmpty && phoneNumber.isNotEmpty && state !='Select' && district !='Select' && level =="Select"){
        if (kDebugMode) {
          print('State , district , name , phoneNumber, level Only');
        }
        if (nameMatched && phoneMatched && stateMatched && districtMatched && levelMatched) {
          filteredList.add(student);
        }
      }else if(name.isNotEmpty && phoneNumber.isEmpty && state =='Select' && district =='Select' && level =="Select"){
        if (kDebugMode) {
          print('name Only');
        }
        if (nameMatched) {
          filteredList.add(student);
        }
      }else if(name.isEmpty && phoneNumber.isEmpty && state !='Select' && district =='Select' && level =="Select"){
        if (kDebugMode) {
          print('State Only');
        }
        if (stateMatched) {
          filteredList.add(student);
        }
      }
      else if(name.isEmpty && phoneNumber.isEmpty && state =='Select' && district =='Select' && level !="Select"){
        if (kDebugMode) {
          print('level Only');
        }
        if (levelMatched) {
          filteredList.add(student);
        }
      }
      else if(name.isEmpty && phoneNumber.isEmpty && state !='Select' && district !='Select' && level =="Select"){
        if (kDebugMode) {
          print('State , district Only');
        }
        if (stateMatched && districtMatched) {
          filteredList.add(student);
        }
      }
      else if(name.isNotEmpty && phoneNumber.isNotEmpty && state =='Select' && district =='Select' && level =="Select"){
        if (kDebugMode) {
          print('name , phoneNumber Only');
        }
        if (nameMatched && phoneMatched){
          filteredList.add(student);
        }
      }
      else if(name.isEmpty && phoneNumber.isNotEmpty && state =='Select' && district =='Select' && level =="Select"){
        if (kDebugMode) {
          print('phoneNumber Only');
        }
        if (phoneMatched) {
          filteredList.add(student);
        }
      }else{
        if (kDebugMode) {
          print('something');
        }
        if(nameMatched || phoneMatched || stateMatched || districtMatched || levelMatched){
          filteredList.add(student);
        }
      }
    }

    Get.to(() => FilterStudentScreen(filteredList));
  }

  void filterStudentListAllAdmin(String state, String district, String franchise ,String level) {
    // Create a new list to store the filtered results
    List<SData> filteredList = [];

    // Iterate over the original studentList
    for (var student in studentList) {

      bool stateMatched = false;
      bool districtMatched = false;
      bool franchiseMatched = false;
      bool levelMatched = false;

      // Check if the studentName contains the input name (case insensitive)
      if (franchise.isNotEmpty) {
        franchiseMatched = student.franchise?.toLowerCase().contains(franchise.toLowerCase()) ?? false;
      }

      // Check if the mobileNumber contains the input phoneNumber
      if (level.isNotEmpty) {
        levelMatched = student.level?.contains(level) ?? false;
      }

      // Check if the state contains the input state (case insensitive)
      if (state != 'Select') {
        stateMatched = student.state?.toLowerCase().contains(state.toLowerCase()) ?? false;
      }

      // Check if the district contains the input district (case insensitive)
      if (district != 'Select') {
        districtMatched = student.district?.toLowerCase().contains(district.toLowerCase()) ?? false;
      }

      // If any of the conditions are met, add it to the filtered list
      if(franchise !='Select' && level !='Select' && state !='Select' && district !='Select'){
        if (kDebugMode) {
          print('State , district , franchise , level Only');
        }
        if (franchiseMatched && levelMatched && stateMatched && districtMatched) {
          filteredList.add(student);
        }
      }else if(state !='Select' && district == 'Select' && franchise == 'Select' && level == 'Select'){
        if (kDebugMode) {
          print('State Only');
        }
        if(stateMatched){
          filteredList.add(student);
        }
      }else if(franchise =='Select' && level =='Select' && state !='Select' && district !='Select'){
        if (kDebugMode) {
          print('State and District Only');
        }
        if (stateMatched && districtMatched) {
          filteredList.add(student);
        }
      }else if(franchise !='Select' && level =='Select' && state !='Select' && district !='Select'){
        if (kDebugMode) {
          print('State , district , franchise Only');
        }
        if (franchiseMatched && stateMatched && districtMatched) {
          filteredList.add(student);
        }
      }else if(state =='Select' && district == 'Select' && franchise != 'Select' && level == 'Select'){
        if (kDebugMode) {
          print('franchise Only');
        }
        if(franchiseMatched){
          filteredList.add(student);
        }
      }else if(state !='Select' && district == 'Select' && franchise != 'Select' && level != 'Select'){
        if (kDebugMode) {
          print('state,level,franchise Only');
        }
        if (franchiseMatched && stateMatched && levelMatched) {
          filteredList.add(student);
        }
      }
      else if(state !='Select' && district == 'Select' && franchise == 'Select' && level != 'Select'){
        if (kDebugMode) {
          print('state,level Only');
        }
        if (stateMatched && levelMatched) {
          filteredList.add(student);
        }
      }else if(state =='Select' && district == 'Select' && franchise != 'Select' && level != 'Select'){
        if (kDebugMode) {
          print('franchise,level Only');
        }
        if (franchiseMatched && levelMatched) {
          filteredList.add(student);
        }
      }
      else if(state !='Select' && district == 'Select' && franchise != 'Select' && level == 'Select'){
        if (kDebugMode) {
          print('state,franchise Only');
        }
        if (stateMatched && franchiseMatched) {
          filteredList.add(student);
        }
      }
      else if(state =='Select' && district == 'Select' && franchise == 'Select' && level != 'Select'){
        if (kDebugMode) {
          print('level Only');
        }
        if(levelMatched){
          filteredList.add(student);
        }
      }
      else{
        if (kDebugMode) {
          print('something');
        }
      }
    }

    Get.to(() => FilterStudentScreen(filteredList));
  }



  void filterFranchiseListAllFranchise(String name, String state, String district) {
    // Create a new list to store the filtered results
    List<FMData> filteredList = [];

    // Iterate over the original FranchiseList
    for (var franchise in approvedfranchiselist) {
      // Check if the studentName, mobileNumber, state, or district contains the input values (case insensitive)
      bool nameMatched = false;
      bool stateMatched = false;
      bool districtMatched = false;

      // Check if the studentName contains the input name (case insensitive)
      if (name.isNotEmpty) {
        nameMatched = franchise.name?.toLowerCase().contains(name.toLowerCase()) ?? false;
      }

      // Check if the state contains the input state (case insensitive)
      if (state != 'Select') {
        stateMatched = franchise.state?.toLowerCase().contains(state.toLowerCase()) ?? false;
      }

      // Check if the district contains the input district (case insensitive)
      if (district != 'Select') {
        districtMatched = franchise.district?.toLowerCase().contains(district.toLowerCase()) ?? false;
      }

      // If any of the conditions are met, add it to the filtered list
      if(name !='Select' && state !='Select' && district !='Select'){
        if (kDebugMode) {
          print('State , district , name Only');
        }
        if (nameMatched && stateMatched && districtMatched) {
          filteredList.add(franchise);
        }
      }else if(state !='Select' && district == 'Select' && name =='Select'){
        if (kDebugMode) {
          print('State Only');
        }
        if(stateMatched){
          filteredList.add(franchise);
        }
      }else if(name =='Select' && state !='Select' && district !='Select'){
        if (kDebugMode) {
          print('State and District Only');
        }
        if (stateMatched && districtMatched) {
          filteredList.add(franchise);
        }
      }else if(name !='Select' && state !='Select' && district =='Select'){
        if (kDebugMode) {
          print('State and name Only');
        }
        if (stateMatched && nameMatched) {
          filteredList.add(franchise);
        }
      }
      else if(state =='Select' && district == 'Select' && name !='Select'){
        if (kDebugMode) {
          print('name Only');
        }
        if(nameMatched){
          filteredList.add(franchise);
        }
      }
      else{
        if (kDebugMode) {
          print('something');
        }
      }
    }
    Get.to(() => FilterFranchiseScreen(filteredList));
  }



  void getFranchiseStudentList() async {
    isLoading.value = true;
    Map<String, dynamic> requestData = {
      "username": "${Prefs.getString(USERNAME)}",
    };
    if (kDebugMode) {
      print(getfranchisestudentUrl);
    }
    RequestDio request =
        RequestDio(url: getfranchisestudentUrl, body: requestData);
    request.post().then((response) async {
      if (response.statusCode == 200) {
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentList.add(element);
          }
          debugPrint("total number of Students : ${studentList.length}");
          isLoading.value = false;
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else if (response.statusCode == 201) {
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentList.add(element);
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


  void getStockList() async {
    isLoading.value = true;
    RequestDio request = RequestDio(url: getallitemsUrl);
    request.post().then((response) async {
      if (response.statusCode == 200) {
        StockModel stock = StockModel.fromJson(response.data);
        if (stock.status == true) {
          for (var element in stock.data!) {
            stockList.add(element);
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
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentList.add(element);
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

  var stockIsLoading = false.obs;

  Future getStockListUpdate() async {
    stockList.clear();
    RequestDio request = RequestDio(url: getallitemsUrl);
    request.post().then((response) async {
      if (response.statusCode == 200) {
        StockModel stock = StockModel.fromJson(response.data);
        if (stock.status == true) {
          List<StData> listElement = [];
          for (var element in stock.data!) {
            listElement.add(element);
            if (kDebugMode) {
              print('${element.name}----->${element.count}');
            }
          }
          refresh();
          if (kDebugMode) {
            print('Inside Stock List Update stock loading value -----> ${stockIsLoading.value}');
          }
          if(stockIsLoading.value == true){
            stockIsLoading.value = false;
          }
          stockList.addAll(listElement);
          stockList.refresh();
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else if (response.statusCode == 201) {
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentList.add(element);
          }

          if(stockIsLoading.value == false){
            stockIsLoading.value = true;
          }
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
      if(stockIsLoading.value == false){
        stockIsLoading.value = true;
      }
    });
    update();
  }


  Future updateStock(int count, String id) async {
    stockIsLoading.value = true;
    update();
    refresh();
    Map<String, dynamic> requestData = {"id": "${id}", "count": "${count}"};

    if (kDebugMode) {
      print(requestData);
      print(getallitemsUrl);
    }
    RequestDio request = RequestDio(url: editItemUrl, body: requestData);
    request.post().then((response) async {
      if (kDebugMode) {
        print(response.data);
      }
      if (response.statusCode == 200) {
        registrationsuccessmodel stock =
            registrationsuccessmodel.fromJson(jsonDecode(response.data));
        if (stock.status == true) {
          Fluttertoast.showToast(msg: stock.message!);
         await getStockListUpdate();
          if (kDebugMode) {
            print('Inside Update stock loading value -----> ${stockIsLoading.value}');
          }
          refresh();
          Get.back();
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else if (response.statusCode == 201) {
        registrationsuccessmodel stock =
            registrationsuccessmodel.fromJson(response.data);
        Fluttertoast.showToast(msg: stock.message!);
        Get.back();
        update();
      } else {
        Get.snackbar("Error", "Fetching error",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP);
      }
      update();
    });
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
