// To parse this JSON data, do
//
//     final seasonModel = seasonModelFromJson(jsonString);

import 'dart:convert';

import 'package:gestion_projects/models/models.dart';

SeasonModel seasonModelFromJson(String str) => SeasonModel.fromJson(json.decode(str));

String seasonModelToJson(SeasonModel data) => json.encode(data.toJson());

class SeasonModel {
  List<StageModel> stagesIds;
  double price;
  bool state;
  String name;
  DateTime start;
  DateTime end;
  String responsible;
  String id;

  SeasonModel({
    required this.stagesIds,
    required this.price,
    required this.state,
    required this.name,
    required this.start,
    required this.end,
    required this.responsible,
    required this.id,
  });

  SeasonModel copyWith({
    List<StageModel>? stagesIds,
    double? price,
    bool? state,
    String? name,
    DateTime? start,
    DateTime? end,
    String? responsible,
    String? id,
  }) =>
      SeasonModel(
        stagesIds: stagesIds ?? this.stagesIds,
        price: price ?? this.price,
        state: state ?? this.state,
        name: name ?? this.name,
        start: start ?? this.start,
        end: end ?? this.end,
        responsible: responsible ?? this.responsible,
        id: id ?? this.id,
      );

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        stagesIds: List<StageModel>.from(json["stagesIds"].map((x) => StageModel.fromJson(x))),
        price: json["price"],
        state: json["state"],
        name: json["name"],
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
        responsible: json["responsible"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "stagesIds": List<dynamic>.from(stagesIds.map((x) => x.toJson())),
        "price": price,
        "state": state,
        "name": name,
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
        "responsible": responsible,
        "id": id,
      };
}
