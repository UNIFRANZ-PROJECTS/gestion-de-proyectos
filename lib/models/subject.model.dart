// To parse this JSON data, do
//
//     final subjectModel = subjectModelFromJson(jsonString);

import 'dart:convert';

import 'teacher.model.dart';

SubjectModel subjectModelFromJson(String str) => SubjectModel.fromJson(json.decode(str));

String subjectModelToJson(SubjectModel data) => json.encode(data.toJson());

class SubjectModel {
  SubjectModel({
    required this.teacherIds,
    required this.state,
    required this.name,
    required this.code,
    required this.semester,
    required this.id,
  });

  List<TeacherModel> teacherIds;
  bool state;
  String name;
  String code;
  int semester;
  String id;

  SubjectModel copyWith({
    List<TeacherModel>? teacherIds,
    bool? state,
    String? name,
    String? code,
    int? semester,
    String? id,
  }) =>
      SubjectModel(
        teacherIds: teacherIds ?? this.teacherIds,
        state: state ?? this.state,
        name: name ?? this.name,
        code: code ?? this.code,
        semester: semester ?? this.semester,
        id: id ?? this.id,
      );

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        teacherIds: List<TeacherModel>.from(json["teacherIds"].map((x) => TeacherModel.fromJson(x))),
        state: json["state"],
        name: json["name"],
        code: json["code"],
        semester: json["semester"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "teacherIds": List<dynamic>.from(teacherIds.map((x) => x.toJson())),
        "state": state,
        "name": name,
        "code": code,
        "semester": semester,
        "id": id,
      };
}
