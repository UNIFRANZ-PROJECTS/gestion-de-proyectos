// To parse this JSON data, do
//
//     final parallelModel = parallelModelFromJson(jsonString);

import 'dart:convert';

import 'package:gestion_projects/models/models.dart';

ParallelModel parallelModelFromJson(String str) => ParallelModel.fromJson(json.decode(str));

String parallelModelToJson(ParallelModel data) => json.encode(data.toJson());

class ParallelModel {
  int name;
  bool state;
  TeacherModel teacherId;
  SubjectModel subjectId;
  String id;

  ParallelModel({
    required this.name,
    required this.state,
    required this.teacherId,
    required this.subjectId,
    required this.id,
  });

  ParallelModel copyWith({
    int? name,
    bool? state,
    TeacherModel? teacherId,
    SubjectModel? subjectId,
    String? id,
  }) =>
      ParallelModel(
        name: name ?? this.name,
        state: state ?? this.state,
        teacherId: teacherId ?? this.teacherId,
        subjectId: subjectId ?? this.subjectId,
        id: id ?? this.id,
      );

  factory ParallelModel.fromJson(Map<String, dynamic> json) => ParallelModel(
        name: json["name"],
        state: json["state"],
        teacherId: TeacherModel.fromJson(json["teacherId"]),
        subjectId: SubjectModel.fromJson(json["subjectId"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "state": state,
        "teacherId": teacherId.toJson(),
        "subjectId": subjectId.toJson(),
        "id": id,
      };
}
