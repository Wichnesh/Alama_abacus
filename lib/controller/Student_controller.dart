import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

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
  var level = "".obs;
  var levelList = [
    'Admission',
    'Level 1',
    'Level 2',
    'Level 3',
    'Level 4',
    'Level 5',
    'Level 6'
  ].obs;

  void updatelevel(String value) {
    level.value = value;
  }
}
