import 'dart:convert';
import 'client_response_model.dart';
import 'role_response_model.dart';
import 'settings_response_model.dart';

class TeamMemberResponseModel {
  final ClientResponseModel? client;
  final int? clientId;
  final String? createdAt;
  final String? email;
  final String? fullName;
  final int? id;
  final String? profileImageUrl;
  final RoleResponseModel? role;
  final int? roleId;
  final SettingsResponseModel? settings;
  final String? updatedAt;

  TeamMemberResponseModel({
    this.client,
    this.clientId,
    this.createdAt,
    this.email,
    this.fullName,
    this.id,
    this.profileImageUrl,
    this.role,
    this.roleId,
    this.settings,
    this.updatedAt,
  });

  factory TeamMemberResponseModel.fromRawJson(String str) =>
      TeamMemberResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TeamMemberResponseModel.fromJson(Map<String, dynamic> json) =>
      TeamMemberResponseModel(
        client: json["client"] == null
            ? null
            : ClientResponseModel.fromJson(json["client"]),
        clientId: json["client_id"],
        createdAt: json["created_at"],
        email: json["email"],
        fullName: json["full_name"],
        id: json["id"],
        profileImageUrl: json["profile_image_url"],
        role: json["role"] == null
            ? null
            : RoleResponseModel.fromJson(json["role"]),
        roleId: json["role_id"],
        settings: json["settings"] == null
            ? null
            : SettingsResponseModel.fromJson(json["settings"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
    "client": client?.toJson(),
    "client_id": clientId,
    "created_at": createdAt,
    "email": email,
    "full_name": fullName,
    "id": id,
    "profile_image_url": profileImageUrl,
    "role": role?.toJson(),
    "role_id": roleId,
    "settings": settings?.toJson(),
    "updated_at": updatedAt,
  };
}
