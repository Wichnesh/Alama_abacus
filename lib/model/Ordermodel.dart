class OrderModel {
  bool? status;
  List<OData>? data;

  OrderModel({this.status, this.data});

  OrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <OData>[];
      json['data'].forEach((v) {
        data!.add(new OData.fromJson(v));
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

class OData {
  String? sId;
  String? studentID;
  String? currentLevel;
  String? futureLevel;
  List<String>? items;
  String? franchise;
  String? program;
  String? createdAt;

  OData(
      {this.sId,
        this.studentID,
        this.currentLevel,
        this.futureLevel,
        this.items,
        this.franchise,
        this.program,
        this.createdAt});

  OData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentID = json['studentID'];
    currentLevel = json['currentLevel'];
    futureLevel = json['futureLevel'];
    items = json['items'].cast<String>();
    franchise = json['franchise'];
    program = json['program'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['studentID'] = this.studentID;
    data['currentLevel'] = this.currentLevel;
    data['futureLevel'] = this.futureLevel;
    data['items'] = this.items;
    data['franchise'] = this.franchise;
    data['program'] = this.program;
    data['createdAt'] = this.createdAt;
    return data;
  }
}


class FranchiseData {
  bool status;
  List<Franchise> data;

  FranchiseData({
    required this.status,
    required this.data,
  });

  factory FranchiseData.fromJson(Map<String, dynamic> json) {
    var franchiseList = json['data'] as List;
    List<Franchise> franchises = franchiseList.map((franchiseJson) {
      return Franchise.fromJson(franchiseJson);
    }).toList();

    return FranchiseData(
      status: json['status'],
      data: franchises,
    );
  }
}

class Franchise {
  String franchiseName;
  List<EnrolledStudent> enrolledStudents;
  List<OrderedItem> ordered;
  Map<String, int> totalItems;

  Franchise({
    required this.franchiseName,
    required this.enrolledStudents,
    required this.ordered,
    required this.totalItems,
  });

  factory Franchise.fromJson(Map<String, dynamic> json) {
    var enrolledStudentsList = json['enrolledStudents'] as List? ?? [];
    var orderedList = json['ordered'] as List? ?? [];

    List<OrderedItem> orderedItems = [];
    if (orderedList != null) {
      orderedItems = orderedList.map((itemJson) {
        return OrderedItem.fromJson(itemJson);
      }).toList();
    }

    Map<String, int> totalItems =
    Map<String, int>.from(json['totalItems'] ?? {});

    List<EnrolledStudent> enrolledStudents = enrolledStudentsList.map((studentJson) {
      return EnrolledStudent.fromJson(studentJson);
    }).toList();

    return Franchise(
      franchiseName: json['franchiseName'] ?? "",
      enrolledStudents: enrolledStudents,
      ordered: orderedItems,
      totalItems: totalItems,
    );
  }
}

class EnrolledStudent {
  String studentName;
  String state;
  String level;
  String district;
  String enrollDate;

  EnrolledStudent({
    required this.studentName,
    required this.state,
    required this.level,
    required this.district,
    required this.enrollDate,
  });

  factory EnrolledStudent.fromJson(Map<String, dynamic> json) {
    return EnrolledStudent(
      studentName: json['studentName'] ?? "",
      state: json['state'] ?? "",
      level: json['level'] ?? "",
      district: json['district'] ?? "",
      enrollDate: json['enrollDate'] ?? "",
    );
  }
}

class OrderedItem {
  String studentName;
  String studentID;
  String state;
  String district;
  String currentLevel;
  String futureLevel;
  String orderDate;

  OrderedItem({
    required this.studentName,
    required this.studentID,
    required this.state,
    required this.district,
    required this.currentLevel,
    required this.futureLevel,
    required this.orderDate,
  });

  factory OrderedItem.fromJson(Map<String, dynamic> json) {
    return OrderedItem(
      studentName: json['studentName'] ?? "",
      studentID: json['studentID'] ?? "",
      state: json['state'] ?? "",
      district: json['district'] ?? "",
      currentLevel: json['currentLevel'] ?? "",
      futureLevel: json['futureLevel'] ?? "",
      orderDate: json['createdAt'] ?? "",
    );
  }
}


