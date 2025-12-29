import 'dart:convert';
import 'client_response_model.dart';
import 'floor_plan_response_model.dart';
import 'team_member_response_model.dart';

class ProjectResponseModel {
  final ClientResponseModel? client;
  final int? clientId;
  final String? createdAt;
  final String? description;
  final String? endDate;
  final List<FloorPlanResponseModel>? floorPlans;
  final int? id;
  final String? imageUrl;
  final String? name;
  final int? progress;
  final String? startDate;
  final List<TeamMemberResponseModel>? teamMembers;
  final String? updatedAt;

  ProjectResponseModel({
    this.client,
    this.clientId,
    this.createdAt,
    this.description,
    this.endDate,
    this.floorPlans,
    this.id,
    this.imageUrl,
    this.name,
    this.progress,
    this.startDate,
    this.teamMembers,
    this.updatedAt,
  });

  factory ProjectResponseModel.fromRawJson(String str) =>
      ProjectResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProjectResponseModel.fromJson(Map<String, dynamic> json) =>
      ProjectResponseModel(
        client: json["client"] == null
            ? null
            : ClientResponseModel.fromJson(json["client"]),
        clientId: json["client_id"],
        createdAt: json["created_at"],
        description: json["description"],
        endDate: json["end_date"],
        floorPlans: json["floor_plans"] == null
            ? []
            : List<FloorPlanResponseModel>.from(
                json["floor_plans"]!.map(
                  (x) => FloorPlanResponseModel.fromJson(x),
                ),
              ),
        id: json["id"],
        imageUrl: json["image_url"],
        name: json["name"],
        progress: json["progress"],
        startDate: json["start_date"],
        teamMembers: json["team_members"] == null
            ? []
            : List<TeamMemberResponseModel>.from(
                json["team_members"]!.map(
                  (x) => TeamMemberResponseModel.fromJson(x),
                ),
              ),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
    "client": client?.toJson(),
    "client_id": clientId,
    "created_at": createdAt,
    "description": description,
    "end_date": endDate,
    "floor_plans": floorPlans == null
        ? []
        : List<dynamic>.from(floorPlans!.map((x) => x.toJson())),
    "id": id,
    "image_url": imageUrl,
    "name": name,
    "progress": progress,
    "start_date": startDate,
    "team_members": teamMembers == null
        ? []
        : List<dynamic>.from(teamMembers!.map((x) => x.toJson())),
    "updated_at": updatedAt,
  };
}
