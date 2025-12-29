import 'dart:convert';
import 'inspection_location_response_model.dart';

class FloorPlanResponseModel {
  final String? createdAt;
  final int? id;
  final String? imageUrl;
  final List<InspectionLocationResponseModel>? inspectionLocations;
  final String? name;
  final int? projectId;

  FloorPlanResponseModel({
    this.createdAt,
    this.id,
    this.imageUrl,
    this.inspectionLocations,
    this.name,
    this.projectId,
  });

  factory FloorPlanResponseModel.fromRawJson(String str) =>
      FloorPlanResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FloorPlanResponseModel.fromJson(Map<String, dynamic> json) =>
      FloorPlanResponseModel(
        createdAt: json["created_at"],
        id: json["id"],
        imageUrl: json["image_url"],
        inspectionLocations: json["inspection_locations"] == null
            ? []
            : List<InspectionLocationResponseModel>.from(
                json["inspection_locations"]!.map(
                  (x) => InspectionLocationResponseModel.fromJson(x),
                ),
              ),
        name: json["name"],
        projectId: json["project_id"],
      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt,
    "id": id,
    "image_url": imageUrl,
    "inspection_locations": inspectionLocations == null
        ? []
        : List<dynamic>.from(inspectionLocations!.map((x) => x.toJson())),
    "name": name,
    "project_id": projectId,
  };
}
