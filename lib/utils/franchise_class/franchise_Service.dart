import 'package:flutter/foundation.dart';
import '../../api/request.dart';
import '../../api/url.dart';
import '../../model/HomeModel.dart';

// Define a FranchiseService class responsible for fetching franchise data

class FranchiseService {
  Future<List<FMData>> getFranchiseList() async {
    List<FMData> approvedFranchiseList = [];
    try {
      RequestDio request = RequestDio(url: getallfranchiseUrl);
      var response = await request.post();
      if (response.statusCode == 200 || response.statusCode == 201) {
        FranchiseModel franchise = FranchiseModel.fromJson(response.data);
        if (franchise.status == true) {
          for (var element in franchise.data!) {
            if (element.approve == true) {
              approvedFranchiseList.add(element);
              if (kDebugMode) {
                print('Approved ${element.franchiseID}');
              }
            } else {
              if (kDebugMode) {
                print('Not Approved ${element.franchiseID}');
              }
            }
          }
        }
      } else {
        throw Exception("Error fetching franchise data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    return approvedFranchiseList;
  }
}