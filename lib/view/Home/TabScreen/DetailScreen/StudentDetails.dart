import 'package:alama_eorder_app/controller/Order_controller.dart';
import 'package:alama_eorder_app/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../model/studentmodel.dart';
import '../../../../utils/colorUtils.dart';

class StudentDetails extends StatelessWidget {
  final SData data;
  const StudentDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                ),
                controller:
                    TextEditingController(text: data.studentID.toString()),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Registration date',
                ),
                controller: TextEditingController(text: data.enrollDate),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                ),
                controller: TextEditingController(text: data.studentName),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Student Email ID',
                ),
                controller: TextEditingController(text: data.email),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Contact No',
                ),
                controller: TextEditingController(text: data.mobileNumber),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'State',
                ),
                controller: TextEditingController(text: data.state),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'District',
                ),
                controller: TextEditingController(text: data.district),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Current Level',
                ),
                controller: TextEditingController(text: data.level),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Program',
                ),
                controller: TextEditingController(text: data.program),
                readOnly: true,
              ),
            ),
            GetBuilder<OrderController>(
                init: OrderController(),
                builder: (controller) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 55,
                            width: 175,
                            color: primaryColor,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      // Change the button color when pressed
                                      return Colors.green;
                                    }
                                    // Return the default button color
                                    return primaryColor;
                                  },
                                ),
                              ),
                              onPressed: () {
                                controller.currentlevel.value = data.level!;
                                if (kDebugMode) {
                                  print(controller.currentlevel.value);
                                }

                                // Increment the level
                                int nextLevel = int.parse(controller
                                        .currentlevel.value
                                        .split(' ')[1]) +
                                    1;

                                // Limit the future level to be no higher than 6
                                if (nextLevel <= 6) {
                                  controller.futurelevel.value =
                                      "Level $nextLevel";
                                } else {
                                  controller.futurelevel.value =
                                      "Level 6"; // Set it to the maximum allowed value
                                }

                                if (kDebugMode) {
                                  print(controller.futurelevel.value);
                                }
                                if (!controller.isDataInitialized) {
                                  controller.data = data;
                                  controller.isDataInitialized = true;
                                }
                                controller.tell();
                                Get.toNamed(ROUTE_ORDER);
                              },
                              child: const SizedBox(
                                height: 50,
                                width: 165,
                                child: Center(
                                  child: Text(
                                    "Order",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            width: 175,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      // Change the button color when pressed
                                      return Colors.green;
                                    }
                                    // Return the default button color
                                    return Colors
                                        .red; // or any other color you want
                                  },
                                ),
                              ),
                              onPressed: () {
                                // Handle the button click event
                                Get.back();
                              },
                              child: Text('Close'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
