// To parse this JSON data, do
//
//     final rolesModel = rolesModelFromJson(jsonString);

import 'dart:convert';

import 'package:gestion_projects/models/permision.model.dart';

List<RolesModel> rolesModelFromJson(String str) =>
    List<RolesModel>.from(json.decode(str).map((x) => RolesModel.fromJson(x)));

String rolesModelToJson(List<RolesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

RolesModel rolItemModelFromJson(String str) => RolesModel.fromJson(json.decode(str));

class RolesModel {
  RolesModel({
    required this.permisionIds,
    required this.state,
    required this.name,
    required this.user,
    required this.id,
  });

  List<PermisionsModel> permisionIds;
  bool state;
  String name;
  User user;
  String id;

  RolesModel copyWith({
    List<PermisionsModel>? permisionIds,
    bool? state,
    String? name,
    User? user,
    String? id,
  }) =>
      RolesModel(
        permisionIds: permisionIds ?? this.permisionIds,
        state: state ?? this.state,
        name: name ?? this.name,
        user: user ?? this.user,
        id: id ?? this.id,
      );

  factory RolesModel.fromJson(Map<String, dynamic> json) => RolesModel(
        permisionIds: List<PermisionsModel>.from(json["permisionIds"].map((x) => PermisionsModel.fromJson(x))),
        state: json["state"],
        name: json["name"],
        user: User.fromJson(json["user"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "permisionIds": List<dynamic>.from(permisionIds.map((x) => x.toJson())),
        "state": state,
        "name": name,
        "user": user.toJson(),
        "id": id,
      };
}

class User {
  User({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  User copyWith({
    String? id,
    String? name,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
