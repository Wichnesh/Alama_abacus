import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controller/FranchiseWiseOrderController.dart';
import '../../../../utils/colorUtils.dart';

class FranchiseWiseOrderReport extends StatelessWidget {
   FranchiseWiseOrderReport({super.key});
  final controller = Get.put(FWOController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Franchise Wise Order Report'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 55,
              width: double.infinity,
              child: TextField(
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? date = DateTime.now();
                  date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now());
                  if (date != null) {
                    controller.fromDate = date;
                    controller.update();
                  }
                },
                controller: controller.fromDateText
                  ..text = DateFormat("MM/dd/yyyy").format(
                      controller.fromDate == null
                          ? DateTime.now()
                          : controller.fromDate ?? DateTime.now()),
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  labelText: "From Date",
                  labelStyle: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 55,
              width: double.infinity,
              child: TextField(
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? date = DateTime.now();

                  date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now());

                  if (date != null) {
                    controller.toDate = date;
                    controller.update();
                  }
                },
                controller: controller.toDateText
                  ..text = DateFormat("MM/dd/yyyy").format(
                      controller.toDate == null
                          ? DateTime.now()
                          : controller.toDate ?? DateTime.now()),
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  labelText: "To Date",
                  labelStyle: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
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
                  controller.validate();
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
