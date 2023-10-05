class StockModel {
  bool? status;
  List<StData>? data;

  StockModel({this.status, this.data});

  StockModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <StData>[];
      json['data'].forEach((v) {
        data!.add(new StData.fromJson(v));
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

class StData {
  String? sId;
  String? name;
  int? count;

  StData({this.sId, this.name, this.count});

  StData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['count'] = this.count;
    return data;
  }
}

class TransactionModel {
  bool? status;
  List<STRData>? data;

  TransactionModel({this.status, this.data});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <STRData>[];
      json['data'].forEach((v) {
        data!.add(STRData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class STRData {
  String? sId;
  String? franchiseName;
  String? studentName;
  String? studentID;
  String? itemName;
  int? quantity;
  String? createdDate;
  int? currentQuantity;
  STRData(
      {this.sId,
      this.franchiseName,
      this.studentName,
      this.studentID,
      this.itemName,
      this.quantity,
      this.createdDate,
        this.currentQuantity
      });

  STRData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    franchiseName = json['franchiseName'];
    studentName = json['studentName'];
    studentID = json['studentID'];
    itemName = json['itemName'];
    quantity = json['quantity'];
    createdDate = json['createdDate'];
    currentQuantity = json['currentQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['franchiseName'] = this.franchiseName;
    data['studentName'] = this.studentName;
    data['studentID'] = this.studentID;
    data['itemName'] = this.itemName;
    data['quantity'] = this.quantity;
    data['createdDate'] = this.createdDate;
    data['currentQuantity'] = this.currentQuantity;
    return data;
  }
}
