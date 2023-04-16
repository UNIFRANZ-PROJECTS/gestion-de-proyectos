// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.rol,
    required this.typeUser,
    required this.name,
    required this.lastName,
    required this.code,
    required this.email,
    required this.responsible,
    required this.id,
    required this.state,
  });

  IdName rol;
  IdName typeUser;
  String name;
  String lastName;
  String code;
  String email;
  IdName responsible;
  String id;
  bool state;

  UserModel copyWith({
    IdName? rol,
    IdName? typeUser,
    String? name,
    String? lastName,
    String? code,
    String? email,
    IdName? responsible,
    String? id,
    bool? state,
  }) =>
      UserModel(
          rol: rol ?? this.rol,
          typeUser: typeUser ?? this.typeUser,
          name: name ?? this.name,
          lastName: lastName ?? this.lastName,
          code: code ?? this.code,
          email: email ?? this.email,
          responsible: responsible ?? this.responsible,
          id: id ?? this.id,
          state: state ?? this.state);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        rol: IdName.fromJson(json["rol"]),
        typeUser: IdName.fromJson(json["typeUser"]),
        name: json["name"],
        lastName: json["lastName"],
        code: json["code"],
        email: json["email"],
        responsible: IdName.fromJson(json["responsible"]),
        id: json["id"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "rol": rol.toJson(),
        "typeUser": typeUser.toJson(),
        "name": name,
        "lastName": lastName,
        "code": code,
        "email": email,
        "responsible": responsible.toJson(),
        "id": id,
        "state": state,
      };
}

class IdName {
  IdName({
    required this.id,
    required this.name,
  });

  String id;
  String name;

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
