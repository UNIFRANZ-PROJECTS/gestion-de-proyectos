// To parse this JSON data, do
//
//     final requirementModel = requirementModelFromJson(jsonString);

import 'dart:convert';

RequirementModel requirementModelFromJson(String str) => RequirementModel.fromJson(json.decode(str));

String requirementModelToJson(RequirementModel data) => json.encode(data.toJson());

class RequirementModel {
  bool state;
  String name;
  String description;
  String responsible;
  String id;

  RequirementModel({
    required this.state,
    required this.name,
    required this.description,
    required this.responsible,
    required this.id,
  });

  RequirementModel copyWith({
    bool? state,
    String? name,
    String? description,
    String? responsible,
    String? id,
  }) =>
      RequirementModel(
        state: state ?? this.state,
        name: name ?? this.name,
        description: description ?? this.description,
        responsible: responsible ?? this.responsible,
        id: id ?? this.id,
      );

  factory RequirementModel.fromJson(Map<String, dynamic> json) => RequirementModel(
        state: json["state"],
        name: json["name"],
        description: json["description"],
        responsible: json["responsible"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "name": name,
        "description": description,
        "responsible": responsible,
        "id": id,
      };
}
