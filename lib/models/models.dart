import 'dart:convert';

import 'package:gestion_projects/models/element.model.dart';
import 'package:gestion_projects/models/parallel.model.dart';
import 'package:gestion_projects/models/project.mode.dart';
import 'package:gestion_projects/models/requirement.model.dart';
import 'package:gestion_projects/models/season.model.dart';
import 'package:gestion_projects/models/stage.model.dart';
import 'package:gestion_projects/models/suscribe.model.dart';
import 'package:gestion_projects/models/teacher.model.dart';
import 'package:gestion_projects/models/subject.model.dart';
import 'package:gestion_projects/models/user.model.dart';
// import 'package:gestion_projects/models/auth.model.dart';

export 'package:gestion_projects/models/project.mode.dart';
export 'package:gestion_projects/models/requirement.model.dart';
export 'package:gestion_projects/models/season.model.dart';
export 'package:gestion_projects/models/stage.model.dart';
export 'package:gestion_projects/models/suscribe.model.dart';
export 'package:gestion_projects/models/teacher.model.dart';
export 'package:gestion_projects/models/subject.model.dart';
export 'package:gestion_projects/models/user.model.dart';
export 'package:gestion_projects/models/element.model.dart';
export 'package:gestion_projects/models/parallel.model.dart';
export 'package:gestion_projects/models/auth.model.dart';

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
//lista de temporadas
List<SeasonModel> listSeasonModelFromJson(String str) =>
    List<SeasonModel>.from(json.decode(str).map((x) => SeasonModel.fromJson(x)));

String listSeasonModelToJson(List<SeasonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//lista de etapas
List<StageModel> listStageModelFromJson(String str) =>
    List<StageModel>.from(json.decode(str).map((x) => StageModel.fromJson(x)));

String listStageModelToJson(List<StageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//lista de requisitos
List<RequirementModel> listRequirementModelFromJson(String str) =>
    List<RequirementModel>.from(json.decode(str).map((x) => RequirementModel.fromJson(x)));
String listRequirementModelToJson(List<RequirementModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//lista de paralelos
List<ParallelModel> listParallelModelFromJson(String str) =>
    List<ParallelModel>.from(json.decode(str).map((x) => ParallelModel.fromJson(x)));

String listParallelModelToJson(List<ParallelModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//lista de inscripciones
List<SuscribeModel> listSuscribeModelFromJson(String str) =>
    List<SuscribeModel>.from(json.decode(str).map((x) => SuscribeModel.fromJson(x)));

String listSuscribeModelToJson(List<SuscribeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
