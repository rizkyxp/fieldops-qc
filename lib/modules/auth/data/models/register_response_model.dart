class RegisterResponseModel {
  final bool success;
  final String message;

  RegisterResponseModel({required this.success, required this.message});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success:
          json['status_code'].toString() == '200' ||
          json['status_code'].toString() == '201',
      message: json['message'] as String,
    );
  }
}
