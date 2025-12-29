import 'dart:convert';

class SettingsResponseModel {
  final bool? emailNotifications;
  final int? id;
  final bool? pushNotifications;
  final String? themePreference;
  final int? userId;

  SettingsResponseModel({
    this.emailNotifications,
    this.id,
    this.pushNotifications,
    this.themePreference,
    this.userId,
  });

  factory SettingsResponseModel.fromRawJson(String str) =>
      SettingsResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SettingsResponseModel.fromJson(Map<String, dynamic> json) =>
      SettingsResponseModel(
        emailNotifications: json["email_notifications"],
        id: json["id"],
        pushNotifications: json["push_notifications"],
        themePreference: json["theme_preference"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
    "email_notifications": emailNotifications,
    "id": id,
    "push_notifications": pushNotifications,
    "theme_preference": themePreference,
    "user_id": userId,
  };
}
