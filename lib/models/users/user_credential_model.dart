class UserCredentialModel {
  const UserCredentialModel({
    required this.email,
    this.presignedPassword,
  });

  factory UserCredentialModel.fromJson(Map<Object?, dynamic> json) {
    return UserCredentialModel(
      email: json['email'],
      presignedPassword: json['presignedPassword'],
    );
  }

  final String email;
  final String? presignedPassword;
}
