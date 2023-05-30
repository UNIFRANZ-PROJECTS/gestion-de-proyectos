// To parse this JSON data, do
//
//     final teacherModel = teacherModelFromJson(jsonString);

import 'dart:convert';

TeacherModel teacherModelFromJson(String str) => TeacherModel.fromJson(json.decode(str));

String teacherModelToJson(TeacherModel data) => json.encode(data.toJson());

class TeacherModel {
  TeacherModel({
    required this.state,
    required this.name,
    required this.lastName,
    required this.ci,
    required this.email,
    required this.user,
    required this.id,
  });

  bool state;
  String name;
  String lastName;
  String ci;
  String email;
  String user;
  String id;

  TeacherModel copyWith(
    String s, {
    bool? state,
    String? name,
    String? lastName,
    String? ci,
    String? email,
    String? user,
    String? id,
  }) =>
      TeacherModel(
        state: state ?? this.state,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        ci: ci ?? this.ci,
        email: email ?? this.email,
        user: user ?? this.user,
        id: id ?? this.id,
      );

  factory TeacherModel.fromJson(Map<String, dynamic> json) => TeacherModel(
        state: json["state"],
        name: json["name"],
        lastName: json["lastName"],
        ci: json["ci"],
        email: json["email"],
        user: json["user"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "name": name,
        "lastName": lastName,
        "ci": ci,
        "email": email,
        "user": user,
        "id": id,
      };
}
