// To parse this JSON data, do
//
//     final typeUserModel = typeUserModelFromJson(jsonString);

import 'dart:convert';

List<TypeUserModel> typeUserModelFromJson(String str) =>
    List<TypeUserModel>.from(json.decode(str).map((x) => TypeUserModel.fromJson(x)));

String typeUserModelToJson(List<TypeUserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

TypeUserModel typeUserItemModelFromJson(String str) => TypeUserModel.fromJson(json.decode(str));

class TypeUserModel {
  TypeUserModel({
    required this.state,
    required this.name,
    required this.user,
    required this.id,
  });

  bool state;
  String name;
  User user;
  String id;

  TypeUserModel copyWith({
    bool? state,
    String? name,
    User? user,
    String? id,
  }) =>
      TypeUserModel(
        state: state ?? this.state,
        name: name ?? this.name,
        user: user ?? this.user,
        id: id ?? this.id,
      );

  factory TypeUserModel.fromJson(Map<String, dynamic> json) => TypeUserModel(
        state: json["state"],
        name: json["name"],
        user: User.fromJson(json["user"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
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
