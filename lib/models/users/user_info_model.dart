enum UserRole {
  manager('client_manager'),
  worker('client_worker');

  const UserRole(this.value);

  final String value;

  static UserRole fromValue(String i) {
    return UserRole.values.firstWhere((e) => e.value == i);
  }
}

class UserInfoModel {
  const UserInfoModel({
    required this.email,
    required this.id,
    required this.role,
  });

  factory UserInfoModel.fromJson(Map<Object?, dynamic> json) {
    return UserInfoModel(
      email: json['email'],
      id: json['id'],
      role: UserRole.fromValue(json['role']),
    );
  }

  final String email;
  final String id;
  final UserRole role;

  Map<String, dynamic> toJson() => {
        'email': email,
        'id': id,
        'role': role.value,
      };
}
