import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../controller/Student_controller.dart';
import '../../../utils/colorUtils.dart';

class EnrollStudentScreen extends StatefulWidget {
  const EnrollStudentScreen({Key? key}) : super(key: key);

  @override
  State<EnrollStudentScreen> createState() => _EnrollStudentScreenState();
}

class _EnrollStudentScreenState extends State<EnrollStudentScreen> {
  StudentController studentController = StudentController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enroll Student'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      studentController.enrollDate = date;
                      studentController.update();
                    }
                  },
                  controller: studentController.enrollDateText
                    ..text = DateFormat("yyyy-MM-dd").format(
                        studentController.enrollDate == null
                            ? DateTime.now()
                            : studentController.enrollDate ?? DateTime.now()),
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: primaryColor,
                    ),
                    labelText: "Enroll Date",
                    labelStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            _nameInput(hint: "Name", icon: Icons.person),
            _emailInput(hint: "Email", icon: Icons.mail),
            _fatherInput(hint: "Father", icon: Icons.person),
            _motherInput(hint: "Mother", icon: Icons.person),
            _contactnoInput(hint: "Contact No", icon: Icons.phone),
            _addressInput(hint: "Address", icon: Icons.location_city_sharp),
            _cityInput(hint: "City", icon: Icons.location_city),
            _StateInput(hint: "State", icon: Icons.location_city),
            _CountryInput(hint: "Country", icon: Icons.location_city),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 55,
                width: double.infinity,
                child: DropdownButtonFormField(
                  hint: Text(
                    studentController.level.value,
                  ),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 25,
                  decoration: const InputDecoration(
                    labelText: "Area",
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
                    if (kDebugMode) {
                      print("val:    ${studentController.level.value}");
                    }
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(
                    0), // Use zero padding to let the Container control padding
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Enroll Student',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
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

  Widget _StateInput({hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: studentController.stateText,
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
        controller: studentController.countryText,
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

  Widget _cityInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: studentController.cityText,
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
