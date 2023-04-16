// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

List<StudentModel> studentModelFromJson(String str) =>
    List<StudentModel>.from(json.decode(str).map((x) => StudentModel.fromJson(x)));

String studentModelToJson(List<StudentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentModel {
  StudentModel({
    required this.sede,
    required this.carrera,
    required this.semestre,
    required this.ci,
    required this.codigo,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.id,
  });

  String sede;
  String carrera;
  String semestre;
  String ci;
  String codigo;
  String nombre;
  String apellido;
  String email;
  String id;

  StudentModel copyWith({
    String? sede,
    String? carrera,
    String? semestre,
    String? ci,
    String? codigo,
    String? nombre,
    String? apellido,
    String? email,
    String? id,
  }) =>
      StudentModel(
        sede: sede ?? this.sede,
        carrera: carrera ?? this.carrera,
        semestre: semestre ?? this.semestre,
        ci: ci ?? this.ci,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
        apellido: apellido ?? this.apellido,
        email: email ?? this.email,
        id: id ?? this.id,
      );

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        sede: json["sede"],
        carrera: json["carrera"],
        semestre: json["semestre"],
        ci: json["ci"],
        codigo: json["codigo"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        email: json["email"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "sede": sede,
        "carrera": carrera,
        "semestre": semestre,
        "ci": ci,
        "codigo": codigo,
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "id": id,
      };
}
