class LoginResponseModel {
  final String token;

  LoginResponseModel({required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return LoginResponseModel(token: data['token'] as String);
  }
}
