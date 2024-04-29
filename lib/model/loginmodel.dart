import 'dart:convert';

class loginmodel {
  bool? status;
  bool? isAdmin;
  String? token;
  String? franchiseState;

  loginmodel({this.status, this.isAdmin, this.token,this.franchiseState});

  loginmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isAdmin = json['isAdmin'];
    token = json['token'];
    franchiseState = json['franchiseState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['isAdmin'] = this.isAdmin;
    data['token'] = this.token;
    data['franchiseState'] =this.franchiseState;
    return data;
  }
}


LoginStatusModel loginStatusModelFromJson(String str) => LoginStatusModel.fromJson(json.decode(str));

String loginStatusModelToJson(LoginStatusModel data) => json.encode(data.toJson());

class LoginStatusModel {
  final bool status;
  final bool approve;

  LoginStatusModel({
    required this.status,
    required this.approve,
  });

  factory LoginStatusModel.fromJson(Map<String, dynamic> json) => LoginStatusModel(
    status: json["status"],
    approve: json["approve"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "approve": approve,
  };
}
