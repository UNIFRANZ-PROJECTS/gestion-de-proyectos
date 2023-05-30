// To parse this JSON data, do
//
//     final subjectModel = subjectModelFromJson(jsonString);

import 'dart:convert';

SubjectModel subjectModelFromJson(String str) => SubjectModel.fromJson(json.decode(str));

String subjectModelToJson(SubjectModel data) => json.encode(data.toJson());

class SubjectModel {
  bool state;
  String name;
  String code;
  int semester;
  String user;
  String id;

  SubjectModel({
    required this.state,
    required this.name,
    required this.code,
    required this.semester,
    required this.user,
    required this.id,
  });

  SubjectModel copyWith({
    bool? state,
    String? name,
    String? code,
    int? semester,
    String? user,
    String? id,
  }) =>
      SubjectModel(
        state: state ?? this.state,
        name: name ?? this.name,
        code: code ?? this.code,
        semester: semester ?? this.semester,
        user: user ?? this.user,
        id: id ?? this.id,
      );

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        state: json["state"],
        name: json["name"],
        code: json["code"],
        semester: json["semester"],
        user: json["user"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "name": name,
        "code": code,
        "semester": semester,
        "user": user,
        "id": id,
      };
}
