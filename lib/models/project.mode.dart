// To parse this JSON data, do
//
//     final projectModel = projectModelFromJson(jsonString);

import 'dart:convert';

import 'package:gestion_projects/models/models.dart';

ProjectModel projectModelFromJson(String str) => ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  ProjectModel({
    required this.subjectIDs,
    required this.studentIds,
    required this.state,
    required this.name,
    required this.description,
    required this.typeProyect,
    required this.category,
    required this.responsible,
    required this.id,
  });

  List<SubjectModel> subjectIDs;
  List<UserModel> studentIds;
  bool state;
  String name;
  String description;
  ElementModel typeProyect;
  ElementModel category;
  String responsible;
  String id;

  ProjectModel copyWith({
    List<SubjectModel>? subjectIDs,
    List<UserModel>? studentIds,
    bool? state,
    String? name,
    String? description,
    ElementModel? typeProyect,
    ElementModel? category,
    String? responsible,
    String? id,
  }) =>
      ProjectModel(
        subjectIDs: subjectIDs ?? this.subjectIDs,
        studentIds: studentIds ?? this.studentIds,
        state: state ?? this.state,
        name: name ?? this.name,
        description: description ?? this.description,
        typeProyect: typeProyect ?? this.typeProyect,
        category: category ?? this.category,
        responsible: responsible ?? this.responsible,
        id: id ?? this.id,
      );

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        subjectIDs: List<SubjectModel>.from(json["subjectIDs"].map((x) => SubjectModel.fromJson(x))),
        studentIds: List<UserModel>.from(json["studentIds"].map((x) => UserModel.fromJson(x))),
        state: json["state"],
        name: json["name"],
        description: json["description"],
        typeProyect: ElementModel.fromJson(json["typeProyect"]),
        category: ElementModel.fromJson(json["category"]),
        responsible: json["responsible"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "subjectIDs": List<dynamic>.from(subjectIDs.map((x) => x.toJson())),
        "studentIds": List<dynamic>.from(studentIds.map((x) => x.toJson())),
        "state": state,
        "name": name,
        "description": description,
        "typeProyect": typeProyect.toJson(),
        "category": category.toJson(),
        "responsible": responsible,
        "id": id,
      };
}

class Responsible {
  Responsible({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  Responsible copyWith({
    String? id,
    String? name,
  }) =>
      Responsible(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Responsible.fromJson(Map<String, dynamic> json) => Responsible(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
