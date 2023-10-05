import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/register_controller.dart';
import '../../utils/ImageUtils.dart';
import '../../utils/colorUtils.dart';
import '../../utils/constant.dart';

class RegisterScreen extends StatefulWidget {
  static const String path = "lib/src/pages/login/login14.dart";
  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController registerController = RegisterController();
  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: <Widget>[
              const HeaderContainer(),
              GetBuilder<RegisterController>(
                  init: RegisterController(),
                  builder: (controller) {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return SizedBox(
                        height: screenheight * 0.9,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              _generateIdInput(
                                  text: controller.Id.value,
                                  hint: "Franchise ID",
                                  icon: Icons.numbers),
                              _nameInput(hint: "Name", icon: Icons.person),
                              _emailInput(hint: "Email", icon: Icons.mail),
                              _contactnoInput(
                                  hint: "Contact No", icon: Icons.home_filled),
                              Obx(() => Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      height: 55,
                                      width: double.infinity,
                                      child: DropdownButtonFormField(
                                        hint: Text(
                                          registerController
                                              .selectedState.value,
                                        ),
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 25,
                                        decoration: const InputDecoration(
                                          labelText: "State",
                                          labelStyle: TextStyle(fontSize: 14),
                                          border: OutlineInputBorder(),
                                        ),
                                        items: registerController.stateData.map(
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
                                          registerController
                                              .updateSelectedState(val!);
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
                                        hint: Text(registerController
                                            .selectedDistrict.value),
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 25,
                                        decoration: const InputDecoration(
                                          labelText: "District",
                                          labelStyle: TextStyle(fontSize: 14),
                                          border: OutlineInputBorder(),
                                        ),
                                        items: registerController.districtData[
                                                registerController
                                                    .selectedState.value]!
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
                                          registerController
                                              .selectedDistrict.value = val!;
                                        },
                                      ),
                                    ),
                                  )),
                              _UsernameInput(
                                  hint: "Username", icon: Icons.person),
                              _PasswordInput(
                                  hint: "Password", icon: Icons.vpn_key),
                              _ConfirmPasswordInput(
                                  hint: "Confirm password",
                                  icon: Icons.vpn_key),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 55,
                                  width: double.infinity,
                                  child: TextField(
                                    readOnly: true,
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      DateTime? date = DateTime.now();
                                      date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now());
                                      if (date != null) {
                                        registerController.date = date;
                                        registerController.update();
                                      }
                                    },
                                    controller: registerController
                                        .registerDateText
                                      ..text = DateFormat("yyyy-MM-dd").format(
                                          registerController.date == null
                                              ? DateTime.now()
                                              : registerController.date ??
                                                  DateTime.now()),
                                    style: const TextStyle(fontSize: 18),
                                    decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.calendar_today,
                                        color: primaryColor,
                                      ),
                                      labelText: "Registration Date",
                                      labelStyle: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  registerController.Id.value = controller.Id.value;
                                  if(registerController.passwordText.text == registerController.confirmPasswordText.text){
                                    registerController.submit();
                                  }else{
                                    Fluttertoast.showToast(msg: "Password not matching");
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
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              RichText(
                                text: TextSpan(children: [
                                  const TextSpan(
                                      text: "Already have an account ? ",
                                      style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: "Login",
                                      style: TextStyle(color: secondaryColor),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.back();
                                        }),
                                ]),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
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

  Widget _nameInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: registerController.nametext,
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
        controller: registerController.emailtext,
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

  Widget _contactnoInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: registerController.contactNo,
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

  Widget _StateInput({hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: registerController.stateText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon, color: primaryColor),
        ),
      ),
    );
  }

  Widget _CountryInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: registerController.countryText,
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

  Widget _UsernameInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: registerController.usernameText,
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

  Widget _PasswordInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: registerController.passwordText,
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

  Widget _ConfirmPasswordInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: registerController.confirmPasswordText,
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

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [secondaryColor, primaryColor],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
          borderRadius:
              const BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          const Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                "Register",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
          Center(
            child: Image.asset(
              logo,
              height: 100,
              width: 100,
            ),
          ),
        ],
      ),
    );
  }
}
