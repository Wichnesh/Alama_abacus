import 'package:alama_eorder_app/utils/colorUtils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constant.dart';

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.toNamed(ROUTE_ENROLLSTUDENT);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
