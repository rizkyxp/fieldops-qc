import 'dart:convert';

class InspectionLocationResponseModel {
  final String? createdAt;
  final int? floorPlanId;
  final int? id;
  final String? label;
  final int? x;
  final int? y;

  InspectionLocationResponseModel({
    this.createdAt,
    this.floorPlanId,
    this.id,
    this.label,
    this.x,
    this.y,
  });

  factory InspectionLocationResponseModel.fromRawJson(String str) =>
      InspectionLocationResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InspectionLocationResponseModel.fromJson(Map<String, dynamic> json) =>
      InspectionLocationResponseModel(
        createdAt: json["created_at"],
        floorPlanId: json["floor_plan_id"],
        id: json["id"],
        label: json["label"],
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt,
    "floor_plan_id": floorPlanId,
    "id": id,
    "label": label,
    "x": x,
    "y": y,
  };
}
