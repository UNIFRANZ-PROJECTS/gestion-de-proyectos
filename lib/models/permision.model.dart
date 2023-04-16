// To parse this JSON data, do
//
//     final permisionsModel = permisionsModelFromJson(jsonString);

import 'dart:convert';

List<PermisionsModel> permisionsModelFromJson(String str) =>
    List<PermisionsModel>.from(json.decode(str).map((x) => PermisionsModel.fromJson(x)));

String permisionsModelToJson(List<PermisionsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

PermisionsModel permisionItemModelFromJson(String str) => PermisionsModel.fromJson(json.decode(str));

class PermisionsModel {
  PermisionsModel({
    required this.state,
    required this.name,
    required this.category,
    required this.id,
  });

  bool state;
  String name;
  String category;
  String id;

  PermisionsModel copyWith({
    bool? state,
    String? name,
    String? category,
    String? id,
  }) =>
      PermisionsModel(
        state: state ?? this.state,
        name: name ?? this.name,
        category: category ?? this.category,
        id: id ?? this.id,
      );

  factory PermisionsModel.fromJson(Map<String, dynamic> json) => PermisionsModel(
        state: json["state"],
        name: json["name"],
        category: json["category"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "name": name,
        "category": category,
        "id": id,
      };
}
