class RegisterRequestModel {
  final String companyName;
  final String email;
  final String name;
  final String password;

  RegisterRequestModel({
    required this.companyName,
    required this.email,
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "company_name": companyName,
    "email": email,
    "name": name,
    "password": password,
  };
}
