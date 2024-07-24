enum UserRole {
  admin('root_admin'),
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
    required this.billingPlan,
  });

  factory UserInfoModel.fromJson(Map<Object?, dynamic> json) {
    return UserInfoModel(
      role: UserRole.fromValue(json['role']),
      email: json['email'],
      name: json['name'],
      billingPlan: json['billingPlan'],
    );
  }

  final UserRole role;
  final String email;
  final String name;
  final int billingPlan;
}
