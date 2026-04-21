import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../api/request.dart';
import '../api/url.dart';
import '../model/HomeModel.dart';
import '../model/Ordermodel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import '../utils/constant.dart';
import '../utils/franchise_class/franchise_Service.dart';
import '../utils/pref_manager.dart';
class FWOController extends GetxController {
  var approvedFranchiseList = List<FMData>.empty(growable: true).obs;
  var selectedFranchise  ="Select".obs;
  var isLoading = false.obs;
  var enableDownload = false.obs;
  var orderList = List<OData>.empty(growable: true).obs;
  var reportList = List<Franchise>.empty(growable: true).obs;
  DateTime? fromDate;
  DateTime? toDate;
  TextEditingController fromDateText = TextEditingController();
  TextEditingController toDateText = TextEditingController();
  var username = "".obs;
  final FranchiseService franchiseService = FranchiseService();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var admin = Prefs.getBoolen(SHARED_ADMIN);
    username.value = Prefs.getString(USERNAME);
    admin ? fetchFranchiseList() : Container();
  }

  void updateSelectedFranchise(String newValue) {
    selectedFranchise.value = newValue;
  }

  void fetchFranchiseList() async {
    approvedFranchiseList.clear();
    try {
      isLoading.value = true;
      approvedFranchiseList.assignAll(await franchiseService.getFranchiseList());
    } catch (e) {
      Get.snackbar("Error", "$e",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  void getReportMethod() {
    var admin = Prefs.getBoolen(SHARED_ADMIN);
    reportList.clear();
    isLoading.value = true;
    update();
    Map<String, dynamic>? requestData;
    requestData = {"startDate": fromDateText.text, "endDate": toDateText.text};
    RequestDio request = RequestDio(url: getallreports, body: requestData);
    if (kDebugMode) {
      print(requestData);
    }
    request.post().then((response) async {
      if (kDebugMode) {
        print(response.data);
        print(response.statusCode);
      }
      if (response.statusCode == 200) {
        FranchiseData order = FranchiseData.fromJson(response.data);
        if (order.status == true) {
          for (var element in order.data) {
          if(admin){
            if(element.franchiseName == selectedFranchise.value){
              reportList.add(element);
            }
          }else{
            if(element.franchiseName == username.value){
              reportList.add(element);
            }
          }
          }
          if (reportList.isNotEmpty) {
            if (kDebugMode) {
              print("Report Is Not Empty");
            }
            enableDownload.value = true;
          } else {
            if (kDebugMode) {
              print("Report Is Empty");
            }
            Fluttertoast.showToast(msg: 'Order Report Is Empty');
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
    });
  }


  void reportGeneratePdf() async {
    final pdf = pw.Document();
    int enrollCounter = 1;
    int orderCounter = 1;
    int itemCounter = 1;
    for (var order in reportList) {
      // Create a table header
      var enrollTableHeaders = [
        pw.Text('S.No', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Student Name',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('District',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('State', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Order Level',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Enroll Date',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ];

      var orderTableHeaders = [
        pw.Text('S.No', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Student Name',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Student ID',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('District',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('State', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Order Level',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Order Date',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ];
      var itemListHeaders = [
        pw.Text('S.No', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Item Name',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Count', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ];

      // Add franchise name to the PDF
      pdf.addPage(
        pw.MultiPage(
          maxPages: 1000,
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Center(
                child: pw.Text('Alama Abacus',
                    style: pw.TextStyle(
                        fontSize: 20, font: pw.Font.courierBold()))),
            pw.SizedBox(height: 20),
            pw.Center(
                child: pw.Text(
                    'Order Report -- ${fromDateText.text} - ${toDateText.text}')),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                'Franchise Name: ${order.franchiseName}',
                style:
                pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
                child: pw.Text('Enroll Details',
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
              data: order.enrolledStudents
                  .map((student) => [
                '${enrollCounter++}',
                student.studentName,
                student.district,
                student.state,
                student.level,
                student.enrollDate
              ])
                  .toList(),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
                child: pw.Text('Order Details',
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: orderTableHeaders,
              cellAlignment: pw.Alignment.center,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center
              },
              data: order.ordered
                  .map((order) => [
                '${orderCounter++}',
                order.studentName,
                order.studentID,
                order.district,
                order.state,
                order.futureLevel,
                order.orderDate
              ])
                  .toList(),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
                child: pw.Text('Item Details',
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: itemListHeaders,
              cellAlignment: pw.Alignment.center,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center
              },
              data: order.totalItems.entries
                  .map((entry) => ['${itemCounter++}', entry.key, entry.value])
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

  void validate() async {
    var admin = Prefs.getBoolen(SHARED_ADMIN);
   if(admin){
     if(selectedFranchise.value == "Select"){
       Fluttertoast.showToast(msg: "Select Franchise to Submit");
     }else{
       getReportMethod();
     }
   }else{
     getReportMethod();
   }
  }
}