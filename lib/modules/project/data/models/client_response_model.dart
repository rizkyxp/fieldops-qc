import 'dart:convert';

class ClientResponseModel {
  final String? address;
  final String? companyName;
  final String? contactEmail;
  final String? createdAt;
  final int? id;
  final String? subscriptionStatus;
  final String? updatedAt;

  ClientResponseModel({
    this.address,
    this.companyName,
    this.contactEmail,
    this.createdAt,
    this.id,
    this.subscriptionStatus,
    this.updatedAt,
  });

  factory ClientResponseModel.fromRawJson(String str) =>
      ClientResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientResponseModel.fromJson(Map<String, dynamic> json) =>
      ClientResponseModel(
        address: json["address"],
        companyName: json["company_name"],
        contactEmail: json["contact_email"],
        createdAt: json["created_at"],
        id: json["id"],
        subscriptionStatus: json["subscription_status"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
    "address": address,
    "company_name": companyName,
    "contact_email": contactEmail,
    "created_at": createdAt,
    "id": id,
    "subscription_status": subscriptionStatus,
    "updated_at": updatedAt,
  };
}
