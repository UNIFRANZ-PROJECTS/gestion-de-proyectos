// To parse this JSON data, do
//
//     final projectModel = projectModelFromJson(jsonString);

import 'dart:convert';

import 'subject.model.dart';
import 'user.model.dart';

ProjectModel projectModelFromJson(String str) => ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  ProjectModel({
    required this.subjectIDs,
    required this.studentIds,
    required this.state,
    required this.responsible,
    required this.name,
    required this.description,
    required this.typeProyect,
    required this.category,
    required this.id,
  });

  List<SubjectModel> subjectIDs;
  List<UserModel> studentIds;
  bool state;
  String responsible;
  String name;
  String description;
  String typeProyect;
  String category;
  String id;

  ProjectModel copyWith({
    List<SubjectModel>? subjectIDs,
    List<UserModel>? studentIds,
    bool? state,
    String? responsible,
    String? name,
    String? description,
    String? typeProyect,
    String? category,
    String? id,
  }) =>
      ProjectModel(
        subjectIDs: subjectIDs ?? this.subjectIDs,
        studentIds: studentIds ?? this.studentIds,
        state: state ?? this.state,
        responsible: responsible ?? this.responsible,
        name: name ?? this.name,
        description: description ?? this.description,
        typeProyect: typeProyect ?? this.typeProyect,
        category: category ?? this.category,
        id: id ?? this.id,
      );

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        subjectIDs: List<SubjectModel>.from(json["subjectIDs"].map((x) => SubjectModel.fromJson(x))),
        studentIds: List<UserModel>.from(json["studentIds"].map((x) => UserModel.fromJson(x))),
        state: json["state"],
        responsible: json["responsible"],
        name: json["name"],
        description: json["description"],
        typeProyect: json["typeProyect"],
        category: json["category"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "subjectIDs": List<dynamic>.from(subjectIDs.map((x) => x.toJson())),
        "studentIds": List<dynamic>.from(studentIds.map((x) => x.toJson())),
        "state": state,
        "responsible": responsible,
        "name": name,
        "description": description,
        "typeProyect": typeProyect,
        "category": category,
        "id": id,
      };
}
