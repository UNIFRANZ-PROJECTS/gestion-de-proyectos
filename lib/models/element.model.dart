// To parse this JSON data, do
//
//     final elementModel = elementModelFromJson(jsonString);

import 'dart:convert';

ElementModel elementModelFromJson(String str) => ElementModel.fromJson(json.decode(str));

String elementModelToJson(ElementModel data) => json.encode(data.toJson());

class ElementModel {
  ElementModel({
    required this.state,
    required this.name,
    required this.id,
  });

  bool state;
  String name;
  String id;

  ElementModel copyWith({
    bool? state,
    String? name,
    String? id,
  }) =>
      ElementModel(
        state: state ?? this.state,
        name: name ?? this.name,
        id: id ?? this.id,
      );

  factory ElementModel.fromJson(Map<String, dynamic> json) => ElementModel(
        state: json["state"],
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "name": name,
        "id": id,
      };
}
