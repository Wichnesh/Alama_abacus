import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../api/request.dart';
import '../api/url.dart';
import '../model/HomeModel.dart';
import '../model/studentmodel.dart';
import 'dart:io';

class FranchiseWiseStudentController extends GetxController {

  var approvedFranchiseList = List<FMData>.empty(growable: true).obs;
  var selectedFranchise  ="Select".obs;
  var isLoading = false.obs;
  var enableDownload = false.obs;
  var studentList = List<SData>.empty(growable: true).obs;

@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFranchiseList();
  }

  void updateSelectedFranchise(String newValue) {
    selectedFranchise.value = newValue;
  }


  void getFranchiseList() async {
    approvedFranchiseList.clear();
    isLoading.value = true;
    RequestDio request = RequestDio(url: getallfranchiseUrl);
    request.post().then((response) async {
      if (response.statusCode == 200) {
        FranchiseModel franchise = FranchiseModel.fromJson(response.data);
        if (franchise.status == true) {
          for (var element in franchise.data!) {
            {
              if (element.approve == true) {
                approvedFranchiseList.add(element);
                if (kDebugMode) {
                  print(approvedFranchiseList);
                }
              } else {
                if (element.approve == false) {
                  if (kDebugMode) {
                    print(element.franchiseID);
                  }
                }
              }
            }
          }
          isLoading.value = false;
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else if (response.statusCode == 201) {
        FranchiseModel franchise = FranchiseModel.fromJson(response.data);
        if (franchise.status == true) {
          for (var element in franchise.data!) {
            {
              if (element.approve == true) {
                approvedFranchiseList.add(element);
                if (element.approve == true) {
                  if (kDebugMode) {
                    print('Approved ${element.franchiseID}');
                  }
                }
              } else {
                //nonapprovedfranchiselist.add(element);
                if (element.approve == false) {
                  if (kDebugMode) {
                    print('Not Approved ${element.franchiseID}');
                  }
                }
              }
            }
          }
          isLoading.value = false;
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else {
        Get.snackbar("Error", "Fetching error",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP);
      }
    }).onError((error, stackTrace) {
      Get.snackbar("Error", "$error",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
      isLoading.value = false;
    });
    update();
  }

  void getFranchiseStudentList() async {
    isLoading.value = true;
    studentList.clear();
    Map<String, dynamic> requestData = {
      "username": selectedFranchise.value,
    };
    if (kDebugMode) {
      print(getfranchisestudentUrl);
    }
    RequestDio request =
    RequestDio(url: getfranchisestudentUrl, body: requestData);
    request.post().then((response) async {
      if (response.statusCode == 200) {
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentList.add(element);
          }
          if (studentList.isNotEmpty) {
            enableDownload.value = true;
          } else {
            enableDownload.value = false;
          }
          debugPrint("total number of Students : ${studentList.length}");
          isLoading.value = false;
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else if (response.statusCode == 201) {
        StudentListModel student = StudentListModel.fromJson(response.data);
        if (student.status == true) {
          for (var element in student.data!) {
            studentList.add(element);
          }
          if (studentList.isNotEmpty) {
            enableDownload.value = true;
          } else {
            enableDownload.value = false;
          }
          isLoading.value = false;
          update();
        } else {
          Get.snackbar("Error", "Fetching error",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
        }
      } else {
        Get.snackbar("Error", "Fetching error",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP);
      }
    }).onError((error, stackTrace) {
      Get.snackbar("Error", "$error",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
      isLoading.value = false;
    });
    update();
  }

  void reportGeneratePdf() async {
    final pdf = pw.Document();
    int enrollCounter = 1;
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now);
    for (var data in studentList) {
      // Create a table header
      var enrollTableHeaders = [
        pw.Text('S.No', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Student ID',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Student Name',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('District',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('State', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Order Level',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ];


      // Add franchise name to the PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Center(
                child: pw.Text('Alama Abacus',
                    style: pw.TextStyle(
                        fontSize: 20, font: pw.Font.courierBold()))),
            pw.SizedBox(height: 20),
            pw.Center(
                child: pw.Text(
                    'Franchise Wise Report - $formattedDate')),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                'Franchise Name: ${selectedFranchise.value}',
                style:
                pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
                child: pw.Text('Student Details',
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 10),
            // Table Headers
            pw.Table.fromTextArray(
              headers: enrollTableHeaders,
              cellAlignment: pw.Alignment.center,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center
              },
              data: studentList
                  .map((student) => [
                '${enrollCounter++}',
                student.studentID,
                student.studentName,
                student.district,
                student.state,
                student.level
              ])
                  .toList(),
            ),
            // Total Items
            pw.SizedBox(height: 20),
          ],
        ),
      );
    }

    // Save the PDF file
    final tempDir = await getTemporaryDirectory();
    final pdfFile = File('${tempDir.path}/pdf${DateTime.now()}.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Open the PDF file
    await OpenFile.open(pdfFile.path);
  }

}