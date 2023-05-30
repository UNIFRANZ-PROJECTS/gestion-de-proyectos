// To parse this JSON data, do
//
//     final projectModel = projectModelFromJson(jsonString);

import 'dart:convert';

import 'package:gestion_projects/models/models.dart';

ProjectModel projectModelFromJson(String str) => ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  Project project;
  List<Materia> materias;

  ProjectModel({
    required this.project,
    required this.materias,
  });

  ProjectModel copyWith({
    Project? project,
    List<Materia>? materias,
  }) =>
      ProjectModel(
        project: project ?? this.project,
        materias: materias ?? this.materias,
      );

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        project: Project.fromJson(json["project"]),
        materias: List<Materia>.from(json["materias"].map((x) => Materia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "project": project.toJson(),
        "materias": List<dynamic>.from(materias.map((x) => x.toJson())),
      };
}

class Materia {
  String parallelId;
  String projectId;
  SubjectModel subjectId;
  TeacherModel teacherId;
  String id;

  Materia({
    required this.parallelId,
    required this.projectId,
    required this.subjectId,
    required this.teacherId,
    required this.id,
  });

  Materia copyWith({
    String? parallelId,
    String? projectId,
    SubjectModel? subjectId,
    TeacherModel? teacherId,
    String? id,
  }) =>
      Materia(
        parallelId: parallelId ?? this.parallelId,
        projectId: projectId ?? this.projectId,
        subjectId: subjectId ?? this.subjectId,
        teacherId: teacherId ?? this.teacherId,
        id: id ?? this.id,
      );

  factory Materia.fromJson(Map<String, dynamic> json) => Materia(
        parallelId: json["parallelId"],
        projectId: json["projectId"],
        subjectId: SubjectModel.fromJson(json["subjectId"]),
        teacherId: TeacherModel.fromJson(json["teacherId"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "parallelId": parallelId,
        "projectId": projectId,
        "subjectId": subjectId.toJson(),
        "teacherId": teacherId.toJson(),
        "id": id,
      };
}

class Project {
  List<StudentId> studentIds;
  bool state;
  String title;
  String generalObjective;
  String researchProblem;
  ElementModel typeProyect;
  ElementModel category;
  String code;
  String responsible;
  SeasonModel season;
  String id;

  Project({
    required this.studentIds,
    required this.state,
    required this.title,
    required this.generalObjective,
    required this.researchProblem,
    required this.typeProyect,
    required this.category,
    required this.code,
    required this.responsible,
    required this.season,
    required this.id,
  });

  Project copyWith({
    List<StudentId>? studentIds,
    bool? state,
    String? title,
    String? generalObjective,
    String? researchProblem,
    ElementModel? typeProyect,
    ElementModel? category,
    String? code,
    String? responsible,
    SeasonModel? season,
    String? id,
  }) =>
      Project(
        studentIds: studentIds ?? this.studentIds,
        state: state ?? this.state,
        title: title ?? this.title,
        generalObjective: generalObjective ?? this.generalObjective,
        researchProblem: researchProblem ?? this.researchProblem,
        typeProyect: typeProyect ?? this.typeProyect,
        category: category ?? this.category,
        code: code ?? this.code,
        responsible: responsible ?? this.responsible,
        season: season ?? this.season,
        id: id ?? this.id,
      );

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        studentIds: List<StudentId>.from(json["studentIds"].map((x) => StudentId.fromJson(x))),
        state: json["state"],
        title: json["title"],
        generalObjective: json["generalObjective"],
        researchProblem: json["researchProblem"],
        typeProyect: ElementModel.fromJson(json["typeProyect"]),
        category: ElementModel.fromJson(json["category"]),
        code: json["code"],
        responsible: json["responsible"],
        season: SeasonModel.fromJson(json["season"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "studentIds": List<dynamic>.from(studentIds.map((x) => x.toJson())),
        "state": state,
        "title": title,
        "generalObjective": generalObjective,
        "researchProblem": researchProblem,
        "typeProyect": typeProyect.toJson(),
        "category": category.toJson(),
        "code": code,
        "responsible": responsible,
        "season": season.toJson(),
        "id": id,
      };
}

class StudentId {
  bool state;
  String name;
  String lastName;
  String email;
  String code;
  String id;

  StudentId({
    required this.state,
    required this.name,
    required this.lastName,
    required this.email,
    required this.code,
    required this.id,
  });

  StudentId copyWith({
    bool? state,
    String? name,
    String? lastName,
    String? email,
    String? code,
    String? id,
  }) =>
      StudentId(
        state: state ?? this.state,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        code: code ?? this.code,
        id: id ?? this.id,
      );

  factory StudentId.fromJson(Map<String, dynamic> json) => StudentId(
        state: json["state"],
        name: json["name"],
        lastName: json["lastName"],
        email: json["email"],
        code: json["code"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "name": name,
        "lastName": lastName,
        "email": email,
        "code": code,
        "id": id,
      };
}
