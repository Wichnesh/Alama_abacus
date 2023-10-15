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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SData {
  String? sId;
  String? studentID;
  String? enrollDate;
  String? studentName;
  String? address;
  String? district;
  String? state;
  String? mobileNumber;
  String? email;
  String? fatherName;
  String? motherName;
  String? franchise;
  String? level;
  bool? enableBool;
  List<String>? items;
  String? tShirt;
  String? program;
  List<int>? cost;
  String? paymentID;
  List<LevelOrders>? levelOrders;

  SData(
      {this.sId,
        this.studentID,
        this.enrollDate,
        this.studentName,
        this.address,
        this.district,
        this.state,
        this.mobileNumber,
        this.email,
        this.fatherName,
        this.motherName,
        this.franchise,
        this.level,
        this.items,
        this.tShirt,
        this.program,
        this.cost,
        this.enableBool,
        this.paymentID,
        this.levelOrders});

  SData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentID = json['studentID'];
    enrollDate = json['enrollDate'];
    studentName = json['studentName'];
    address = json['address'];
    district = json['district'];
    state = json['state'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    fatherName = json['fatherName'];
    motherName = json['motherName'];
    franchise = json['franchise'];
    level = json['level'];
    items = json['items'].cast<String>();
    tShirt = json['tShirt'];
    program = json['program'];
    enableBool = json['enableBtn'] ?? '';
    cost = json['cost'].cast<int>();
    paymentID = json['paymentID'];
    if (json['levelOrders'] != null) {
      levelOrders = <LevelOrders>[];
      json['levelOrders'].forEach((v) {
        levelOrders!.add(LevelOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['studentID'] = studentID;
    data['enrollDate'] = enrollDate;
    data['studentName'] = studentName;
    data['address'] = address;
    data['district'] = district;
    data['state'] = state;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['fatherName'] = fatherName;
    data['motherName'] = motherName;
    data['franchise'] = franchise;
    data['level'] = level;
    data['items'] = items;
    data['tShirt'] = tShirt;
    data['program'] = program;
    data['cost'] = cost;
    data['enableBtn'] = enableBool;
    data['paymentID'] = paymentID;
    if (levelOrders != null) {
      data['levelOrders'] = levelOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LevelOrders {
  String? level;
  String? date;
  String? sId;

  LevelOrders({this.level, this.date, this.sId});

  LevelOrders.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    date = json['date'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = level;
    data['date'] = date;
    data['_id'] = sId;
    return data;
  }
}


class CartStudentList {
  bool? status;
  List<CSLData>? data;

  CartStudentList({this.status, this.data});

  CartStudentList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CSLData>[];
      json['data'].forEach((v) {
        data!.add(CSLData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CSLData {
  String? sId;
  String? studentID;
  String? enrollDate;
  String? studentName;
  String? address;
  String? district;
  String? state;
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
  List<CartLevelOrders>? levelOrders;
  String? paymentID; // Add paymentId property here

  CSLData(
      {this.sId,
        this.studentID,
        this.enrollDate,
        this.studentName,
        this.address,
        this.district,
        this.state,
        this.mobileNumber,
        this.email,
        this.fatherName,
        this.motherName,
        this.franchise,
        this.level,
        this.items,
        this.tShirt,
        this.program,
        this.cost,
        this.levelOrders,
        this.paymentID,
      });

  CSLData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentID = json['studentID'];
    enrollDate = json['enrollDate'];
    studentName = json['studentName'];
    address = json['address'];
    district = json['district'];
    state = json['state'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    fatherName = json['fatherName'];
    motherName = json['motherName'];
    franchise = json['franchise'];
    level = json['level'];
    items = json['items'].cast<String>();
    tShirt = json['tShirt'];
    program = json['program'];
    paymentID = json['paymentID'];
    cost = json['cost'].cast<int>();
    if (json['levelOrders'] != null) {
      levelOrders = <CartLevelOrders>[];
      json['levelOrders'].forEach((v) {
        levelOrders!.add(CartLevelOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['studentID'] = studentID;
    data['enrollDate'] = enrollDate;
    data['studentName'] = studentName;
    data['address'] = address;
    data['district'] = district;
    data['state'] = state;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['fatherName'] = fatherName;
    data['motherName'] = motherName;
    data['franchise'] = franchise;
    data['level'] = level;
    data['items'] = items;
    data['tShirt'] = tShirt;
    data['program'] = program;
    data['cost'] = cost;
    data['paymentID'] = paymentID;
    if (levelOrders != null) {
      data['levelOrders'] = levelOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartLevelOrders {
  String? level;
  String? program;
  String? date;
  String? sId;

  CartLevelOrders({this.level, this.program, this.date, this.sId});

  CartLevelOrders.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    program = json['program'];
    date = json['date'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = level;
    data['program'] = program;
    data['date'] = date;
    data['_id'] = sId;
    return data;
  }
}

