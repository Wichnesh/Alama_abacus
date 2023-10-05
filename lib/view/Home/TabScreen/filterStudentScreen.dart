import 'package:alama_eorder_app/model/studentmodel.dart';
import 'package:alama_eorder_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'DetailScreen/StudentDetails.dart';

class FilterStudentScreen extends StatelessWidget {
  FilterStudentScreen(this.filteredList, {super.key});
  List<SData> filteredList = [];

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.all(_w / 30),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: filteredList.length,
          itemBuilder: (BuildContext c, int i) {
            var data = filteredList[i];
            if (filteredList.isEmpty) {
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
      )
    );
  }
}
