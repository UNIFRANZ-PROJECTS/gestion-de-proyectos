// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool state;
  IdName rol;
  IdName typeUser;
  String name;
  String lastName;
  String code;
  String email;
  IdName responsible;
  String id;

  UserModel({
    required this.state,
    required this.rol,
    required this.typeUser,
    required this.name,
    required this.lastName,
    required this.code,
    required this.email,
    required this.responsible,
    required this.id,
  });

  UserModel copyWith({
    bool? state,
    IdName? rol,
    IdName? typeUser,
    String? name,
    String? lastName,
    String? code,
    String? email,
    IdName? responsible,
    String? id,
  }) =>
      UserModel(
        state: state ?? this.state,
        rol: rol ?? this.rol,
        typeUser: typeUser ?? this.typeUser,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        code: code ?? this.code,
        email: email ?? this.email,
        responsible: responsible ?? this.responsible,
        id: id ?? this.id,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        state: json["state"],
        rol: IdName.fromJson(json["rol"]),
        typeUser: IdName.fromJson(json["typeUser"]),
        name: json["name"],
        lastName: json["lastName"],
        code: json["code"],
        email: json["email"],
        responsible: IdName.fromJson(json["responsible"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "rol": rol.toJson(),
        "typeUser": typeUser.toJson(),
        "name": name,
        "lastName": lastName,
        "code": code,
        "email": email,
        "responsible": responsible.toJson(),
        "id": id,
      };
}

class IdName {
  String id;
  String name;

  IdName({
    required this.id,
    required this.name,
  });

  IdName copyWith({
    String? id,
    String? name,
  }) =>
      IdName(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory IdName.fromJson(Map<String, dynamic> json) => IdName(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
