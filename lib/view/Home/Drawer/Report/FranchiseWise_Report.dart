import 'package:alama_eorder_app/utils/colorUtils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../../controller/FranchiseWiseStudent_controller.dart';
import '../../../../controller/Home_controller.dart';


class FranchiseWiseStudentScreen extends StatelessWidget {
  FranchiseWiseStudentScreen({super.key});
  FranchiseWiseStudentController controller = Get.put(FranchiseWiseStudentController());
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Franchise Wise Student Report'),
      ),
      body: Column(
        children: [
          Obx(() => Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: DropdownButtonFormField(
                hint: Text(
                  controller.selectedFranchise.value,
                ),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 25,
                decoration: const InputDecoration(
                  focusColor: primaryColor,
                  labelText: "Franchise",
                  labelStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(

                  ),
                ),
                items: controller.approvedFranchiseList.map(
                      (val) {
                    return DropdownMenuItem<String>(
                      value: val.username ??'',
                      child: Text(
                        val.username??'',
                      ),
                      onTap: () {
                      },
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  controller.updateSelectedFranchise(val!);
                },
              ),
            ),
          )),
          ElevatedButton(
              onPressed: (){
                controller.getFranchiseStudentList();
              },
              child: const Text("Submit")
          ),
          Obx(() => controller.enableDownload.isTrue
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
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
                      if (controller.enableDownload.isTrue) {
                        controller.reportGeneratePdf();
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Data Not Available');
                      }
                    },
                    child: const SizedBox(
                      height: 50,
                      width: 165,
                      child: Center(
                        child: Text(
                          "Download PDF",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              : Container()),
        ],
      ),
    );
  }
}
