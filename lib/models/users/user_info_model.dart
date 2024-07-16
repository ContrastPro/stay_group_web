enum UserRole {
  admin('team_admin'),
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
    required this.role,
    required this.email,
    required this.name,
  });

  factory UserInfoModel.fromJson(Map<Object?, dynamic> json) {
    return UserInfoModel(
      role: UserRole.fromValue(json['role']),
      email: json['email'],
      name: json['name'],
    );
  }

  final UserRole role;
  final String email;
  final String name;
}
