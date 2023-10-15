import 'package:alama_eorder_app/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../controller/Student_controller.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/pref_manager.dart';

class EnrollStudentScreen extends StatefulWidget {
  const EnrollStudentScreen({Key? key}) : super(key: key);

  @override
  State<EnrollStudentScreen> createState() => _EnrollStudentScreenState();
}

class _EnrollStudentScreenState extends State<EnrollStudentScreen> {
  StudentController studentController = StudentController();
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  void payment() async {
    int totalCost = 0;
    if (studentController.admission.value == true &&
        studentController.levelCost.value == false) {
      totalCost = 1300 * 100;
    } else if (studentController.admission.value == false &&
        studentController.levelCost.value == true) {
      totalCost = 500 * 100;
    } else if (studentController.admission.value == true &&
        studentController.levelCost.value == true) {
      totalCost = 1800 * 100;
    }
    var options = {
      'key': 'rzp_test_r0nbHDzzVtfN6m',
      'amount': totalCost,
      'name': studentController.nameText.text,
      'description': 'Payment',
      'prefill': {
        'contact': studentController.mobileNoText.text,
        'email': studentController.emailText.text
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS PAYMENT: ${response.paymentId}", timeInSecForIosWeb: 4);
    if (response.orderId == null) {
      studentController.paymentID.value = response.paymentId!;
      studentController.submit();
    } else {
      studentController.orderID.value = response.orderId!;
      studentController.paymentID.value = response.paymentId!;
      studentController.submit();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR HERE: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET IS : ${response.walletName}",
        timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    String franchiseState = Prefs.getString(FRANCHISESTATE);
    return GetBuilder<StudentController>(builder: (controllor) {
      if (controllor.isLoading.value) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Enroll Student'),
            centerTitle: true,
            actions: [
              IconButton(onPressed: (){
                Get.offAllNamed(ROUTE_STUDENTCARTLISTSCREEN);
              }, icon: const Icon(Icons.shopping_cart))
            ],
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        studentController.Id.value = controllor.Id.value;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Enroll Student'),
            centerTitle: true,
            actions: [
              IconButton(onPressed: (){
                Get.offAllNamed(ROUTE_STUDENTCARTLISTSCREEN);
              }, icon: const Icon(Icons.shopping_cart))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _generateIdInput(
                    text: studentController.Id.value,
                    hint: "Student ID",
                    icon: Icons.numbers),
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
                          studentController.enrollDate = date;
                          studentController.update();
                        }
                      },
                      controller: studentController.enrollDateText
                        ..text = DateFormat("yyyy-MM-dd").format(
                            studentController.enrollDate == null
                                ? DateTime.now()
                                : studentController.enrollDate ??
                                    DateTime.now()),
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: primaryColor,
                        ),
                        labelText: "Enroll Date *",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                _nameInput(hint: "Name *", icon: Icons.person),
                _emailInput(hint: "Email *", icon: Icons.mail),
                _fatherInput(hint: "Father", icon: Icons.person),
                _motherInput(hint: "Mother", icon: Icons.person),
                _contactnoInput(hint: "Contact No *", icon: Icons.phone),
                _addressInput(hint: "Address", icon: Icons.location_city_sharp),
                Obx(() => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          hint: Text(
                            studentController.selectedState.value,
                          ),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 25,
                          decoration: const InputDecoration(
                            labelText: "State *",
                            labelStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(),
                          ),
                          items: studentController.stateData.map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(
                                  val,
                                ),
                                onTap: () {
                                },
                              );
                            },
                          ).toList(),
                          onChanged: (val){
                            studentController.updateSelectedState(val!);
                            if(franchiseState == 'Tamil Nadu'){
                              print('Selected Tamil Nadu');
                              studentController.costBool.value = true;
                              studentController.costBoolUpdate(franchiseState);
                            }else{
                              print('Other States selected');
                              studentController.costBool.value = false;
                              studentController.costBoolUpdate(franchiseState);
                            }
                          },
                        ),
                      ),
                    )),
                Obx(() => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          hint: Text(studentController.selectedDistrict.value),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 25,
                          decoration: const InputDecoration(
                            labelText: "District *",
                            labelStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(),
                          ),
                          items: studentController.districtData[
                                  studentController.selectedState.value]!
                              .map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(
                                  val,
                                ),
                                onTap: () {},
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            studentController.selectedDistrict.value = val!;
                          },
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(
                        studentController.level.value,
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "Level *",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: studentController.levelList.map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                            ),
                            onTap: () {},
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        studentController.updatelevel(val!);
                        studentController.costBoolUpdate(franchiseState);
                        studentController.preLevelCheckBox();
                      },
                    ),
                  ),
                ),
                Obx((){
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: DropdownButtonFormField(
                        hint: Text(
                          studentController.program.value,
                        ),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 25,
                        decoration: const InputDecoration(
                          labelText: "Program",
                          labelStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(),
                        ),
                        items: studentController.programList.map(
                              (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(
                                val,
                              ),
                              onTap: () {},
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          studentController.updateProgramList(val!);
                          studentController.programBoolUpdate();
                          studentController.programBool.value = true;
                          if (kDebugMode) {
                            print("val:    ${studentController.program.value}");
                          }
                        },
                      ),
                    ),
                  );
                }),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Items :',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    CheckboxListTile(
                      enabled: false,
                      title: const Text('Pencil'),
                      value: studentController.pencil.value,
                      onChanged: (value) {
                        studentController.setPencil(value!);
                      },
                    ),
                    CheckboxListTile(
                      enabled: false,
                      title: const Text('Student Bag'),
                      value: studentController.bag.value,
                      onChanged: (value) {
                        studentController.setBag(value!);
                      },
                    ),
                    CheckboxListTile(
                      enabled: false,
                      title: const Text('Student Abacus'),
                      value: studentController.studentAbacus.value,
                      onChanged: (value) {
                        studentController.setStudentAbacus(value!);
                      },
                    ),
                    CheckboxListTile(
                      enabled: false,
                      title: const Text('Listening Ability'),
                      value: studentController.listeningAbility.value,
                      onChanged: (value) {
                        studentController.setListeningAbility(value!);
                      },
                    ),
                    CheckboxListTile(
                      enabled: false,
                      title: const Text('Progress Card'),
                      value: studentController.progressCard.value,
                      onChanged: (value) {
                        studentController.setProgressCard(value!);
                      },
                    ),
                    CheckboxListTile(
                      enabled: false,
                      title: const Text('Speed Writing Book'),
                      value: studentController.speedWritingBook.value,
                      onChanged: (value) {
                        studentController.setSpeedWritingBook(value!);
                      },
                    ),
                    Obx((){
                      if(studentController.programBool.value){
                        return Column(
                          children: [
                            CheckboxListTile(
                              enabled: false,
                              title: Text('${studentController.programValue.value} CB 1 Book'),
                              value: studentController.cb1Book.value,
                              onChanged: (value) {
                                studentController.setCb1Book(value!);
                              },
                            ),
                            CheckboxListTile(
                              enabled: false,
                              title: Text('${studentController.programValue.value} PB 1 Book'),
                              value: studentController.pb1Book.value,
                              onChanged: (value) {
                                studentController.setPd1Book(value!);
                              },
                            ),
                          ],
                        );
                      }else{
                        return Container();
                      }
                    }),
                    Obx((){
                      if(studentController.enablePreLevelCheckBox.value){
                        return Column(
                          children: [
                            CheckboxListTile(
                              enabled: false,
                              title: const Text('Pre Level 1'),
                              value: studentController.preLevel1.value,
                              onChanged: (value) {
                                studentController.setPreLevel(value!);
                              },
                            ),
                            CheckboxListTile(
                              enabled: false,
                              title: const Text('Pre Level 2'),
                              value: studentController.pb1Book.value,
                              onChanged: (value) {
                                studentController.setPreLevel(value!);
                              },
                            ),
                          ],
                        );
                      }else{
                        return Container();
                      }
                    }),
                    CheckboxListTile(
                      title: const Text('T-Shirt *'),
                      value: studentController.isChecked.value,
                      onChanged: (newValue) {
                        studentController.toggleCheckbox(newValue!);
                        setState(() {});
                        debugPrint(
                            'value -- > ${studentController.selectedShirt.value}');
                      },
                    ),
                    studentController.isChecked.value
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 55,
                              width: double.infinity,
                              child: DropdownButtonFormField(
                                hint: studentController
                                        .selectedShirt.value.isEmpty
                                    ? const Text(
                                        'Select',
                                      )
                                    : Text(
                                        studentController.selectedShirt.value,
                                      ),
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 25,
                                decoration: const InputDecoration(
                                  labelText: "T-Shirt",
                                  labelStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(),
                                ),
                                items: studentController.tShirtSize.map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text('T-Shirt Size $val'),
                                      onTap: () {},
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  studentController.updateTShirt(val!);
                                  if (kDebugMode) {
                                    print(
                                        "val:    ${studentController.selectedShirt.value}");
                                  }
                                },
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Costs : ',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                   Obx((){
                     if(studentController.costBool.value){
                       return  CheckboxListTile(
                         enabled: false,
                         title:  Text('Admission : ${studentController.enrollValue.value}'),
                         value: studentController.admission.value,
                         onChanged: (value) {
                           studentController.setAdmission(value!);
                           setState(() {});
                         },
                       );
                     }else{
                       return  CheckboxListTile(
                         enabled: false,
                         title:  Text('Admission : ${studentController.enrollValue.value}'),
                         value: studentController.admission.value,
                         onChanged: (value) {
                           studentController.setAdmission(value!);
                           setState(() {});
                         },
                       );
                     }
                   })
                    // CheckboxListTile(
                    //   title: const Text('Level : 500'),
                    //   value: studentController.levelCost.value,
                    //   onChanged: (value) {
                    //     studentController.setLevelCost(value!);
                    //     setState(() {});
                    //   },
                    // ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (studentController.nameText.text.isEmpty ||
                        studentController.emailText.text.isEmpty ||
                        studentController.mobileNoText.text.isEmpty ||
                        studentController.level.value == 'Select' ||
                        studentController.isChecked.value == false ||
                        studentController.program.value == 'Select'
                    ) {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Fill mandatory data'),
                          content: const Text('marked *'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      studentController.addUnpaidStudent();
                     // print('Data Filled');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(
                        0), // Use zero padding to let the Container control padding
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Add Student',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _generateIdInput({String? text, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: TextEditingController(text: text),
        readOnly: true,
        enabled: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _nameInput({hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: studentController.nameText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _emailInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: studentController.emailText,
        keyboardType: TextInputType.emailAddress, // Use email keyboard type
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon, color: primaryColor),
        ),
        validator: (value) {
          if (!value!.contains('@') || !value.contains('.')) {
            return 'Enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _contactnoInput({hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: studentController.mobileNoText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: primaryColor,
          ),
        ),
      ),
    );
  }


  Widget _fatherInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: studentController.fatherText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _motherInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: studentController.motherText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _addressInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: studentController.addressText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

}
