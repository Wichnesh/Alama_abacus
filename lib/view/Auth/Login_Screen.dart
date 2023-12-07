import 'package:alama_eorder_app/utils/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controller/login_controller.dart';
import '../../utils/ImageUtils.dart';
import '../../utils/colorUtils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController controller = Get.put(loginController());
  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: SizedBox(
          height: Screenheight,
          child: Column(
            children: <Widget>[
              const HeaderContainer(),
              SizedBox(
                height: Screenheight * 0.4,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _emailInput(hint: "User name", icon: Icons.email),
                      SizedBox(
                        height: Screenheight * 0.01,
                      ),
                      _passwordInput(hint: "Password", icon: Icons.vpn_key),
                      SizedBox(
                        height: Screenheight * 0.1,
                      ),
                      Obx(() {
                        if(controller.isLoading.value){
                          return const Center(child: CircularProgressIndicator(),);
                        }else{
                          return ElevatedButton(
                            onPressed: () {
                              if (controller.emailtext.text.isEmpty ||
                                  controller.passwordtext.text.isEmpty) {
                                Get.snackbar(
                                    "Warning", "Enter both Username & Password",
                                    colorText: Colors.white,
                                    backgroundColor: Colors.orange,
                                    snackPosition: SnackPosition.TOP);
                              } else {
                                controller.onInit();
                                controller.login();
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
                                'Login',
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                      const Spacer(),
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: "Don't have an account ? ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "Register",
                              style: TextStyle(color: secondaryColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(ROUTE_REGISTER);
                                }),

                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Obx(() => Center(child: Text("Version : ${controller.version.value} + ${controller.build.value}"),))
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailInput({hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller.emailtext,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon, color: primaryColor),
        ),
      ),
    );
  }

  Widget _passwordInput({hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller.passwordtext,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon, color: primaryColor),
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
                "Login",
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
