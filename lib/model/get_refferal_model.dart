// To parse this JSON data, do
//
//     final getRefferalModel = getRefferalModelFromJson(jsonString);

import 'dart:convert';

GetRefferalModel getRefferalModelFromJson(String str) => GetRefferalModel.fromJson(json.decode(str));

String getRefferalModelToJson(GetRefferalModel data) => json.encode(data.toJson());

class GetRefferalModel {
    bool? status;
    List<Datum>? data;
    int? count;

    GetRefferalModel({
        this.status,
        this.data,
        this.count,
    });

    GetRefferalModel copyWith({
        bool? status,
        List<Datum>? data,
        int? count,
    }) => 
        GetRefferalModel(
            status: status ?? this.status,
            data: data ?? this.data,
            count: count ?? this.count,
        );

    factory GetRefferalModel.fromJson(Map<String, dynamic> json) => GetRefferalModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "count": count,
    };
}

class Datum {
    String? id;
    String? franchiseId;
    String? phoneNumber;
    String? name;
    DateTime? createdAt;
    int? v;

    Datum({
        this.id,
        this.franchiseId,
        this.phoneNumber,
        this.name,
        this.createdAt,
        this.v,
    });

    Datum copyWith({
        String? id,
        String? franchiseId,
        String? phoneNumber,
        String? name,
        DateTime? createdAt,
        int? v,
    }) => 
        Datum(
            id: id ?? this.id,
            franchiseId: franchiseId ?? this.franchiseId,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            name: name ?? this.name,
            createdAt: createdAt ?? this.createdAt,
            v: v ?? this.v,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        franchiseId: json["franchiseID"],
        phoneNumber: json["phoneNumber"],
        name: json["name"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "franchiseID": franchiseId,
        "phoneNumber": phoneNumber,
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
    };
}
