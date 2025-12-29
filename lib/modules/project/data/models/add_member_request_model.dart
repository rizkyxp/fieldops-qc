class AddMemberRequestModel {
  final String email;
  final int userId;

  AddMemberRequestModel({required this.email, required this.userId});

  Map<String, dynamic> toJson() => {"email": email, "user_id": userId};
}
