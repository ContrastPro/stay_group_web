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
    required this.name,
    this.billingPlan,
  });

  factory UserInfoModel.fromJson(Map<Object?, dynamic> json) {
    return UserInfoModel(
      role: UserRole.fromValue(json['role']),
      name: json['name'],
      billingPlan: json['billingPlan'],
    );
  }

  final UserRole role;
  final String name;
  final int? billingPlan;
}
