class StudentListModel {
  bool? status;
  List<SData>? data;

  StudentListModel({this.status, this.data});

  StudentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SData>[];
      json['data'].forEach((v) {
        data!.add(SData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SData {
  String? sId;
  int? studentID;
  String? enrollDate;
  String? studentName;
  String? address;
  String? state;
  String? district;
  String? mobileNumber;
  String? email;
  String? fatherName;
  String? motherName;
  String? franchise;
  String? level;
  List<String>? items;
  String? tShirt;
  String? program;
  List<int>? cost;

  SData(
      {this.sId,
      this.studentID,
      this.enrollDate,
      this.studentName,
      this.address,
      this.state,
      this.district,
      this.mobileNumber,
      this.email,
      this.fatherName,
      this.motherName,
      this.franchise,
      this.level,
      this.items,
      this.tShirt,
      this.program,
      this.cost});

  SData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentID = json['studentID'];
    enrollDate = json['enrollDate'];
    studentName = json['studentName'];
    address = json['address'];
    state = json['state'];
    district = json['district'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    fatherName = json['fatherName'];
    motherName = json['motherName'];
    franchise = json['franchise'];
    level = json['level'];
    items = json['items'].cast<String>();
    tShirt = json['tShirt'];
    program = json['program'];
    cost = json['cost'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['studentID'] = this.studentID;
    data['enrollDate'] = this.enrollDate;
    data['studentName'] = this.studentName;
    data['address'] = this.address;
    data['state'] = this.state;
    data['district'] = this.district;
    data['mobileNumber'] = this.mobileNumber;
    data['email'] = this.email;
    data['fatherName'] = this.fatherName;
    data['motherName'] = this.motherName;
    data['franchise'] = this.franchise;
    data['level'] = this.level;
    data['items'] = this.items;
    data['tShirt'] = this.tShirt;
    data['program'] = this.program;
    data['cost'] = this.cost;
    return data;
  }
}
