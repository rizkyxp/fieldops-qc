import 'dart:convert';
import 'permission_response_model.dart';

class RoleResponseModel {
  final String? description;
  final int? id;
  final String? name;
  final List<PermissionResponseModel>? permissions;

  RoleResponseModel({this.description, this.id, this.name, this.permissions});

  factory RoleResponseModel.fromRawJson(String str) =>
      RoleResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoleResponseModel.fromJson(Map<String, dynamic> json) =>
      RoleResponseModel(
        description: json["description"],
        id: json["id"],
        name: json["name"],
        permissions: json["permissions"] == null
            ? []
            : List<PermissionResponseModel>.from(
                json["permissions"]!.map(
                  (x) => PermissionResponseModel.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "id": id,
    "name": name,
    "permissions": permissions == null
        ? []
        : List<dynamic>.from(permissions!.map((x) => x.toJson())),
  };
}
