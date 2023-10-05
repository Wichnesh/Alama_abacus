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