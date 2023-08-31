class FranchiseModel {
  bool? status;
  List<FMData>? data;

  FranchiseModel({this.status, this.data});

  FranchiseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FMData>[];
      json['data'].forEach((v) {
        data!.add(FMData.fromJson(v));
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

class FMData {
  String? sId;
  String? franchiseID;
  String? name;
  String? email;
  String? contactNumber;
  String? state;
  String? country;
  String? username;
  String? password;
  String? registerDate;
  bool? isAdmin;
  bool? approve;

  FMData(
      {this.sId,
      this.franchiseID,
      this.name,
      this.email,
      this.contactNumber,
      this.state,
      this.country,
      this.username,
      this.password,
      this.registerDate,
      this.isAdmin,
      this.approve});

  FMData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    franchiseID = json['franchiseID'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    state = json['state'];
    country = json['country'];
    username = json['username'];
    password = json['password'];
    registerDate = json['registerDate'];
    isAdmin = json['isAdmin'];
    approve = json['approve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['franchiseID'] = this.franchiseID;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contactNumber'] = this.contactNumber;
    data['state'] = this.state;
    data['country'] = this.country;
    data['username'] = this.username;
    data['password'] = this.password;
    data['registerDate'] = this.registerDate;
    data['isAdmin'] = this.isAdmin;
    data['approve'] = this.approve;
    return data;
  }
}

class ApprovedModel {
  bool? status;
  String? msg;

  ApprovedModel({this.status, this.msg});

  ApprovedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}
