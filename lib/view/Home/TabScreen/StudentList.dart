import 'package:alama_eorder_app/utils/colorUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../controller/Home_controller.dart';
import '../../../utils/constant.dart';
import '../../../utils/pref_manager.dart';
import 'DetailScreen/StudentDetails.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

  HomeController homeController = Get.find<HomeController>();
  Future<void> showFilterDialogAdmin() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,setState){
          return AlertDialog(
            title: const Text('Filter Options'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dropdown 1
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(
                        homeController.selectedState.value,
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "State",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: homeController.stateData.map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                            ),
                            onTap: () {
                              setState(() {

                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          homeController.updateSelectedState(val!);
                        });

                      },
                    ),
                  ),
                ),
                // Dropdown 2
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(homeController.selectedDistrict.value),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "District",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: homeController.districtData[homeController.selectedState.value]!
                          .map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                            ),
                            onTap: () {
                              setState(() {

                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          homeController.selectedDistrict.value = val!;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(
                        homeController.selectedFranchise.value,
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "Franchise",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: homeController.approvedfranchiselist.map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val.name,
                            child: Text(
                              val.name!,
                            ),
                            onTap: () {
                              setState(() {

                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          homeController.updateSelectedFranchise(val!);
                        });

                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(
                        homeController.selectedLevel.value,
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "Level",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: homeController.levelList.map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                            ),
                            onTap: () {
                              setState(() {

                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          homeController.updateSelectedLevel(val!);
                        });

                      },
                    ),
                  ),
                ),

              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Clear'),
              ),
              TextButton(
                onPressed: () {
                  homeController.filterStudentListAllAdmin(
                      homeController.selectedState.value,
                      homeController.selectedDistrict.value,
                      homeController.selectedFranchise.value,
                      homeController.selectedLevel.value
                  );
                },
                child: const Text('Apply'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> showFilterDialogFranchise() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,setState){
          return AlertDialog(
            title: const Text('Filter Options'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text Field 1
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: homeController.nametext,
                    decoration: const InputDecoration(labelText: 'Student Name'),
                  ),
                ),
                // Text Field 2
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: homeController.contactNo,
                    decoration: const InputDecoration(labelText: 'Student Contact No'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(
                        homeController.selectedLevel.value,
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "Level",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: homeController.levelList.map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                            ),
                            onTap: () {
                              setState(() {

                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          homeController.updateSelectedLevel(val!);
                        });

                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(
                        homeController.selectedState.value,
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "State",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: homeController.stateData.map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                            ),
                            onTap: () {
                              setState(() {

                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          homeController.updateSelectedState(val!);
                        });

                      },
                    ),
                  ),
                ),
                // Dropdown 2
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(homeController.selectedDistrict.value),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "District",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: homeController.districtData[homeController.selectedState.value]!
                          .map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                            ),
                            onTap: () {
                              setState(() {

                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          homeController.selectedDistrict.value = val!;
                        });
                      },
                    ),
                  ),
                ),

              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Clear'),
              ),
              TextButton(
                onPressed: () {
                  homeController.filterStudentListAll(homeController.nametext.text,homeController.contactNo.text,homeController.selectedLevel.value,homeController.selectedState.value,homeController.selectedDistrict.value);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool admin = Prefs.getBoolen(SHARED_ADMIN);
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: admin ?  IconButton(
          onPressed: (){
           Get.toNamed(ROUTE_ORDERREPORTS);
          },
          icon: const Icon(Icons.newspaper),
        ) : IconButton(
            onPressed: (){
              Get.toNamed(ROUTE_STUDENTCARTLISTSCREEN);
            },
            icon: const Icon(Icons.shopping_cart)
        ),
        title: const Text('Student List'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                homeController.selectedDistrict.value = "Select";
                homeController.selectedState.value = "Select";
                homeController.nametext.text = "";
                homeController.contactNo.text ="";
                homeController.selectedLevel.value = "Select";
                homeController.selectedFranchise.value = "Select";
                admin ? showFilterDialogAdmin() : showFilterDialogFranchise();
              },
              icon: const Icon(Icons.filter_alt_rounded)
          )
        ],
      ),
      body: GetBuilder<HomeController>(
        init: HomeController(),
        builder: ((controller) {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.all(_w / 30),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: controller.studentList.length,
                itemBuilder: (BuildContext c, int i) {
                  var data = controller.studentList[i];
                  if (controller.studentList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Data',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  } else {
                    return AnimationConfiguration.staggeredList(
                      position: i,
                      delay: const Duration(milliseconds: 100),
                      child: SlideAnimation(
                        duration: const Duration(milliseconds: 2500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        horizontalOffset: 30,
                        verticalOffset: 300.0,
                        child: FlipAnimation(
                          duration: const Duration(milliseconds: 3000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          flipAxis: FlipAxis.y,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => StudentDetails(data: data));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: _w / 20),
                              height: _w / 5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(data.studentName!),
                                subtitle: Text(data.mobileNumber!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          }
        }),
      ),
      floatingActionButton: admin
          ? Container()
          : FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                Get.toNamed(ROUTE_ENROLLSTUDENT);
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
