import 'package:alama_eorder_app/controller/Order_controller.dart';
import 'package:alama_eorder_app/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controller/Home_controller.dart';
import '../../../../controller/Student_controller.dart';
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
        centerTitle: false,
      //   Edit button in right corner
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(()=>IconButton(
                onPressed: () {
                  Get.find<HomeController>().isStudentEdit.value = !Get.find<HomeController>().isStudentEdit.value ;
                },
                icon: Icon(Get.find<HomeController>().isStudentEdit.value?Icons.edit_off:Icons.edit),
              )),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(()=>Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  // border: Get.find<HomeController>().isStudentEdit.value?const OutlineInputBorder():null,
                ),
                controller:
                    TextEditingController(text: data.studentID.toString()),
                readOnly: true,//!Get.find<HomeController>().isStudentEdit.value,
                onChanged: (value) => Get.find<StudentController>().updateStudentData['studentID'] = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Registration date',
                  // border: Get.find<HomeController>().isStudentEdit.value?const OutlineInputBorder():null,
                ),
                controller: TextEditingController(text: data.enrollDate),
                readOnly: true,//!Get.find<HomeController>().isStudentEdit.value,
                onChanged: (value) => Get.find<StudentController>().updateStudentData['enrollDate'] = value,

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Franchise Under',
                  border: Get.find<HomeController>().isStudentEdit.value?const OutlineInputBorder():null,
                ),
                controller: TextEditingController(text: data.franchise),
                readOnly: !Get.find<HomeController>().isStudentEdit.value,
                onChanged: (value) => Get.find<StudentController>().updateStudentData['franchise'] = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: Get.find<HomeController>().isStudentEdit.value?const OutlineInputBorder():null,
                ),
                controller: TextEditingController(text: data.studentName),
                readOnly: !Get.find<HomeController>().isStudentEdit.value,
                onChanged: (value) => Get.find<StudentController>().updateStudentData['studentName'] = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Student Email ID',
                  border: Get.find<HomeController>().isStudentEdit.value?const OutlineInputBorder():null,
                ),
                controller: TextEditingController(text: data.email),
                readOnly: !Get.find<HomeController>().isStudentEdit.value,
                onChanged: (value) => Get.find<StudentController>().updateStudentData['email'] = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Contact No',
                  border: Get.find<HomeController>().isStudentEdit.value?const OutlineInputBorder():null,
                ),
                controller: TextEditingController(text: data.mobileNumber),
                readOnly: !Get.find<HomeController>().isStudentEdit.value,
                onChanged: (value) => Get.find<StudentController>().updateStudentData['mobileNumber'] = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'State',
                  border: Get.find<HomeController>().isStudentEdit.value?const OutlineInputBorder():null,
                ),
                controller: TextEditingController(text: data.state),
                readOnly: !Get.find<HomeController>().isStudentEdit.value,
                onChanged: (value) => Get.find<StudentController>().updateStudentData['state'] = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'District',
                  border: Get.find<HomeController>().isStudentEdit.value?const OutlineInputBorder():null,
                ),
                controller: TextEditingController(text: data.district),
                readOnly: !Get.find<HomeController>().isStudentEdit.value,
                onChanged: (value) => Get.find<StudentController>().updateStudentData['district'] = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Current Level',
                  // border: Get.find<HomeController>().isStudentEdit.value?const OutlineInputBorder():null,
                ),
                controller: TextEditingController(text: data.level),
                readOnly: true,//!Get.find<HomeController>().isStudentEdit.value,
                onChanged: (value) => Get.find<StudentController>().updateStudentData['level'] = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Program',
                  // border: Get.find<HomeController>().isStudentEdit.value?const OutlineInputBorder():null,
                ),
                controller: TextEditingController(text: data.program),
                readOnly: true,//!Get.find<HomeController>().isStudentEdit.value,
                onChanged: (value) => Get.find<StudentController>().updateStudentData['program'] = value,
              ),
            ),
            data.levelOrders!.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(data.enrollDate!),
                        trailing: const Text('Level 1'),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.levelOrders!.isEmpty
                              ? 0
                              : data.levelOrders!.length,
                          itemBuilder: (context, index) {
                            if (data.levelOrders!.isEmpty) {
                              return Container();
                            } else {
                              DateTime? transactionDate =
                                  data.levelOrders![index] != null
                                      ? DateTime.parse(
                                          data.levelOrders![index].date!)
                                      : null;
                              String? formattedDate = transactionDate != null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(transactionDate)
                                  : null;
                              return Padding(
                                padding: const EdgeInsets.all(8.00),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title: Text(formattedDate.toString()),
                                    trailing:
                                        Text(data.levelOrders![index].level!),
                                  ),
                                ),
                              );
                            }
                          }),
                    ],
                  ),
            GetBuilder<OrderController>(
                init: OrderController(),
                builder: (controller) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        data.program == 'MA' && data.level == 'Level 6'
                            ? Container()
                            : Expanded(
                                child: Container(
                                  height: 55,
                                  width: 175,
                                  color: primaryColor,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.pressed)) {
                                            // Change the button color when pressed
                                            return Colors.green;
                                          }
                                          // Return the default button color
                                          return primaryColor;
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.currentlevel.value =
                                          data.level!;
                                      if (kDebugMode) {
                                        print(controller.currentlevel.value);
                                      }
                                      if (controller.currentlevel.value ==
                                              'Enroll' ||
                                          controller.currentlevel.value ==
                                              'Pre Level') {
                                        controller.futurelevel.value =
                                            'Level 1';
                                        if (!controller.isDataInitialized) {
                                          controller.data = data;
                                          controller.isDataInitialized = true;
                                        }
                                        controller.tell();
                                      } else {
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
                                              "Level 6";
                                        }
                                        if (!controller.isDataInitialized) {
                                          controller.data = data;
                                          controller.isDataInitialized = true;
                                        }
                                        controller.tell();
                                      }
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
                            child: Obx(()=>ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:Get.find<HomeController>().isStudentEdit.value?
                                MaterialStateProperty.all(Colors.green):MaterialStateProperty.all(primaryColor),
                              ),
                              onPressed: Get.find<StudentController>().isLoading.value?null:
                                  () async{
                                if(Get.find<HomeController>().isStudentEdit.value){
                                  await Get.find<StudentController>().updateStudent(data.studentID!);
                                }else{
                                  Get.find<HomeController>().isStudentEdit.value = true;
                                }
                              },
                              child:  Get.find<StudentController>().isLoading.value?const Text("Updating...",style: TextStyle(color: Colors.white),):
                              Text(Get.find<HomeController>().isStudentEdit.value?"Save":"Edit",style: TextStyle(color: Colors.white),),
                            )),
                          ),
                        ),
                      ],
                    ),
                  );
                })
          ],
        )),
      ),
    );
  }
}
