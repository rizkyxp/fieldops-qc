import 'dart:convert';

class LoginResponseModel {
  final String token;

  LoginResponseModel({required this.token});

  factory LoginResponseModel.fromRawJson(String str) =>
      LoginResponseModel.fromJson(json.decode(str));

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(token: json["token"]);
}
