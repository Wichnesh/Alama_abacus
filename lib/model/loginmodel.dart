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
