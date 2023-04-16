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
    required this.description,
    required this.specialty,
    required this.user,
    required this.id,
  });

  bool state;
  String name;
  String lastName;
  String description;
  String specialty;
  String user;
  String id;

  TeacherModel copyWith({
    bool? state,
    String? name,
    String? lastName,
    String? description,
    String? specialty,
    String? user,
    String? id,
  }) =>
      TeacherModel(
        state: state ?? this.state,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        description: description ?? this.description,
        specialty: specialty ?? this.specialty,
        user: user ?? this.user,
        id: id ?? this.id,
      );

  factory TeacherModel.fromJson(Map<String, dynamic> json) => TeacherModel(
        state: json["state"],
        name: json["name"],
        lastName: json["lastName"],
        description: json["description"],
        specialty: json["specialty"],
        user: json["user"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "name": name,
        "lastName": lastName,
        "description": description,
        "specialty": specialty,
        "user": user,
        "id": id,
      };
}
