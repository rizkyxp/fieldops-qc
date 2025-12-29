import 'dart:convert';

class PermissionResponseModel {
  final String? description;
  final int? id;
  final String? slug;

  PermissionResponseModel({this.description, this.id, this.slug});

  factory PermissionResponseModel.fromRawJson(String str) =>
      PermissionResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PermissionResponseModel.fromJson(Map<String, dynamic> json) =>
      PermissionResponseModel(
        description: json["description"],
        id: json["id"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
    "description": description,
    "id": id,
    "slug": slug,
  };
}
