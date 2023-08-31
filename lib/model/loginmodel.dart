class loginmodel {
  bool? status;
  bool? isAdmin;
  String? token;

  loginmodel({this.status, this.isAdmin, this.token});

  loginmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isAdmin = json['isAdmin'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['isAdmin'] = this.isAdmin;
    data['token'] = this.token;
    return data;
  }
}
