import 'dart:convert';

import 'package:gestion_projects/models/element.model.dart';
import 'package:gestion_projects/models/project.mode.dart';
import 'package:gestion_projects/models/teacher.model.dart';
import 'package:gestion_projects/models/subject.model.dart';
import 'package:gestion_projects/models/user.model.dart';

export 'package:gestion_projects/models/project.mode.dart';
export 'package:gestion_projects/models/teacher.model.dart';
export 'package:gestion_projects/models/subject.model.dart';
export 'package:gestion_projects/models/user.model.dart';
export 'package:gestion_projects/models/element.model.dart';

//lista de profesores
List<TeacherModel> listTeacherModelFromJson(String str) =>
    List<TeacherModel>.from(json.decode(str).map((x) => TeacherModel.fromJson(x)));

String teacherModelToList(List<TeacherModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//lista de materias
List<SubjectModel> listSubjectModelFromJson(String str) =>
    List<SubjectModel>.from(json.decode(str).map((x) => SubjectModel.fromJson(x)));

String subjectModelToList(List<SubjectModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//lista de proyectos
List<ProjectModel> listProjectModelFromJson(String str) =>
    List<ProjectModel>.from(json.decode(str).map((x) => ProjectModel.fromJson(x)));

String projectModelToList(List<ProjectModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//listas de usuaruis
List<UserModel> listUserModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToList(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//lista de elemntos
List<ElementModel> listElementModelFromJson(String str) =>
    List<ElementModel>.from(json.decode(str).map((x) => ElementModel.fromJson(x)));

String elementModelToList(List<ElementModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
