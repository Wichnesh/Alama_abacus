// To parse this JSON data, do
//
//     final statusModel = statusModelFromJson(jsonString);

import 'dart:convert';

StatusModel statusModelFromJson(String str) => StatusModel.fromJson(json.decode(str));

String statusModelToJson(StatusModel data) => json.encode(data.toJson());

class StatusModel {
    bool? status;
    Data? data;

    StatusModel({
        this.status,
        this.data,
    });

    StatusModel copyWith({
        bool? status,
        Data? data,
    }) => 
        StatusModel(
            status: status ?? this.status,
            data: data ?? this.data,
        );

    factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    List<All>? all;
    Counts? counts;

    Data({
        this.all,
        this.counts,
    });

    Data copyWith({
        List<All>? all,
        Counts? counts,
    }) => 
        Data(
            all: all ?? this.all,
            counts: counts ?? this.counts,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        all: json["all"] == null ? [] : List<All>.from(json["all"]!.map((x) => All.fromJson(x))),
        counts: json["counts"] == null ? null : Counts.fromJson(json["counts"]),
    );

    Map<String, dynamic> toJson() => {
        "all": all == null ? [] : List<dynamic>.from(all!.map((x) => x.toJson())),
        "counts": counts?.toJson(),
    };
}

class All {
    String? id;
    String? name;
    String? phone;
    String? franchiseName;
    String? linkId;
    String? uniqueId;
    bool? franchiseUniqueLink;
    String? status;
    bool? assignedByAdmin;
    bool? submitted;
    int? v;
    bool? interested;
    String? state;
    DateTime? submittedAt;
    String? className;

    All({
        this.id,
        this.name,
        this.phone,
        this.franchiseName,
        this.linkId,
        this.uniqueId,
        this.franchiseUniqueLink,
        this.status,
        this.assignedByAdmin,
        this.submitted,
        this.v,
        this.interested,
        this.state,
        this.submittedAt,
        this.className,
    });

    All copyWith({
        String? id,
        String? name,
        String? phone,
        String? franchiseName,
        String? linkId,
        String? uniqueId,
        bool? franchiseUniqueLink,
        String? status,
        bool? assignedByAdmin,
        bool? submitted,
        int? v,
        bool? interested,
        String? state,
        DateTime? submittedAt,
        String? className,
    }) => 
        All(
            id: id ?? this.id,
            name: name ?? this.name,
            phone: phone ?? this.phone,
            franchiseName: franchiseName ?? this.franchiseName,
            linkId: linkId ?? this.linkId,
            uniqueId: uniqueId ?? this.uniqueId,
            franchiseUniqueLink: franchiseUniqueLink ?? this.franchiseUniqueLink,
            status: status ?? this.status,
            assignedByAdmin: assignedByAdmin ?? this.assignedByAdmin,
            submitted: submitted ?? this.submitted,
            v: v ?? this.v,
            interested: interested ?? this.interested,
            state: state ?? this.state,
            submittedAt: submittedAt ?? this.submittedAt,
            className: className ?? this.className,
        );

    factory All.fromJson(Map<String, dynamic> json) => All(
        id: json["_id"],
        name: json["name"],
        phone: json["phone"],
        franchiseName: json["franchiseName"],
        linkId: json["linkId"],
        uniqueId: json["uniqueId"],
        franchiseUniqueLink: json["franchiseUniqueLink"],
        status: json["status"],
        assignedByAdmin: json["assignedByAdmin"],
        submitted: json["submitted"],
        v: json["__v"],
        interested: json["interested"],
        state: json["state"],
        submittedAt: json["submittedAt"] == null ? null : DateTime.parse(json["submittedAt"]),
        className: json["classs"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "phone": phone,
        "franchiseName": franchiseName,
        "linkId": linkId,
        "uniqueId": uniqueId,
        "franchiseUniqueLink": franchiseUniqueLink,
        "status": status,
        "assignedByAdmin": assignedByAdmin,
        "submitted": submitted,
        "__v": v,
        "interested": interested,
        "state": state,
        "submittedAt": submittedAt?.toIso8601String(),
        "classs": className,
    };
}

class Counts {
    int? total;

    Counts({
        this.total,
    });

    Counts copyWith({
        int? total,
    }) => 
        Counts(
            total: total ?? this.total,
        );

    factory Counts.fromJson(Map<String, dynamic> json) => Counts(
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
    };
}
