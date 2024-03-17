import 'package:alama_eorder_app/controller/Home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/HomeModel.dart';

class franchiseDetail extends StatelessWidget {
  final FMData data;
  const franchiseDetail({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Franchaise Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Franchise ID',
                ),
                controller: TextEditingController(text: data.franchiseID),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Registration date',
                ),
                controller: TextEditingController(text: data.registerDate),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                controller: TextEditingController(text: data.name),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Email ID',
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
                controller: TextEditingController(text: data.contactNumber),
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
                  labelText: 'Username',
                ),
                controller: TextEditingController(text: data.username),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                controller: TextEditingController(text: data.password),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Approved',
                ),
                controller:
                    TextEditingController(text: data.approve.toString()),
                readOnly: true,
              ),
            ),
          //   Button to change the approval status expanded button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.find<HomeController>().reject(data.franchiseID!);
                  Get.back();
                },
                child: const Text('Reject'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
