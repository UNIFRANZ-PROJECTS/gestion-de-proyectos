// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

import 'role.model.dart';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  bool ok;
  String uid;
  String name;
  String lastName;
  String email;
  String code;
  RolesModel rol;
  String typeUser;
  bool valid;
  bool isSuperUser;
  String token;

  AuthModel({
    required this.ok,
    required this.uid,
    required this.name,
    required this.lastName,
    required this.email,
    required this.code,
    required this.rol,
    required this.typeUser,
    required this.valid,
    required this.isSuperUser,
    required this.token,
  });

  AuthModel copyWith({
    bool? ok,
    String? uid,
    String? name,
    String? lastName,
    String? email,
    String? code,
    RolesModel? rol,
    String? typeUser,
    bool? valid,
    bool? isSuperUser,
    String? token,
  }) =>
      AuthModel(
        ok: ok ?? this.ok,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        code: code ?? this.code,
        rol: rol ?? this.rol,
        typeUser: typeUser ?? this.typeUser,
        valid: valid ?? this.valid,
        isSuperUser: isSuperUser ?? this.isSuperUser,
        token: token ?? this.token,
      );

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        ok: json["ok"],
        uid: json["uid"],
        name: json["name"],
        lastName: json["lastName"],
        email: json["email"],
        code: json["code"],
        rol: RolesModel.fromJson(json["rol"]),
        typeUser: json["type_user"],
        valid: json["valid"],
        isSuperUser: json["isSuperUser"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "uid": uid,
        "name": name,
        "lastName": lastName,
        "email": email,
        "code": code,
        "rol": rol.toJson(),
        "type_user": typeUser,
        "valid": valid,
        "isSuperUser": isSuperUser,
        "token": token,
      };
}
