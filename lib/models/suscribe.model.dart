// To parse this JSON data, do
//
//     final suscribeModel = suscribeModelFromJson(jsonString);

import 'dart:convert';

SuscribeModel suscribeModelFromJson(String str) => SuscribeModel.fromJson(json.decode(str));

String suscribeModelToJson(SuscribeModel data) => json.encode(data.toJson());

class SuscribeModel {
  bool state;
  String season;
  Responsible student;
  Responsible responsible;
  DateTime updatedAt;
  DateTime createdAt;
  String id;

  SuscribeModel({
    required this.state,
    required this.season,
    required this.student,
    required this.responsible,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  SuscribeModel copyWith({
    bool? state,
    String? season,
    Responsible? student,
    Responsible? responsible,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? id,
  }) =>
      SuscribeModel(
        state: state ?? this.state,
        season: season ?? this.season,
        student: student ?? this.student,
        responsible: responsible ?? this.responsible,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
      );

  factory SuscribeModel.fromJson(Map<String, dynamic> json) => SuscribeModel(
        state: json["state"],
        season: json["season"],
        student: Responsible.fromJson(json["student"]),
        responsible: Responsible.fromJson(json["responsible"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "season": season,
        "student": student.toJson(),
        "responsible": responsible.toJson(),
        "updatedAt": updatedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "id": id,
      };
}

class Responsible {
  bool state;
  String id;
  String name;
  String lastName;
  String code;
  String email;

  Responsible({
    required this.state,
    required this.id,
    required this.name,
    required this.lastName,
    required this.code,
    required this.email,
  });

  Responsible copyWith({
    bool? state,
    String? id,
    String? name,
    String? lastName,
    String? code,
    String? email,
  }) =>
      Responsible(
        state: state ?? this.state,
        id: id ?? this.id,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        code: code ?? this.code,
        email: email ?? this.email,
      );

  factory Responsible.fromJson(Map<String, dynamic> json) => Responsible(
        state: json["state"],
        id: json["_id"],
        name: json["name"],
        lastName: json["lastName"],
        code: json["code"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "_id": id,
        "name": name,
        "lastName": lastName,
        "code": code,
        "email": email,
      };
}
