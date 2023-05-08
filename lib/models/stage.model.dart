// To parse this JSON data, do
//
//     final stageModel = stageModelFromJson(jsonString);

import 'dart:convert';

import 'requirement.model.dart';

StageModel stageModelFromJson(String str) => StageModel.fromJson(json.decode(str));

String stageModelToJson(StageModel data) => json.encode(data.toJson());

class StageModel {
  List<RequirementModel> requirementIds;
  bool state;
  String name;
  DateTime start;
  DateTime end;
  int weighing;
  String id;

  StageModel({
    required this.requirementIds,
    required this.state,
    required this.name,
    required this.start,
    required this.end,
    required this.weighing,
    required this.id,
  });

  StageModel copyWith({
    List<RequirementModel>? requirementIds,
    bool? state,
    String? name,
    DateTime? start,
    DateTime? end,
    int? weighing,
    String? id,
  }) =>
      StageModel(
        requirementIds: requirementIds ?? this.requirementIds,
        state: state ?? this.state,
        name: name ?? this.name,
        start: start ?? this.start,
        end: end ?? this.end,
        weighing: weighing ?? this.weighing,
        id: id ?? this.id,
      );

  factory StageModel.fromJson(Map<String, dynamic> json) => StageModel(
        requirementIds: List<RequirementModel>.from(json["requirementIds"].map((x) => RequirementModel.fromJson(x))),
        state: json["state"],
        name: json["name"],
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
        weighing: json["weighing"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "requirementIds": List<dynamic>.from(requirementIds.map((x) => x.toJson())),
        "state": state,
        "name": name,
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
        "weighing": weighing,
        "id": id,
      };
}
