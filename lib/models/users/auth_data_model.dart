class AuthDataModel {
  const AuthDataModel({
    required this.email,
    required this.password,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      email: json['email'],
      password: json['password'],
    );
  }

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
