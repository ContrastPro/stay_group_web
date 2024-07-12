enum UserRole {
  manager('client_manager'),
  worker('client_worker');

  const UserRole(this.value);

  final String value;

  static UserRole fromValue(String i) {
    return UserRole.values.firstWhere((e) => e.value == i);
  }
}

class UserModel {
  const UserModel({
    required this.email,
    required this.id,
    required this.role,
    this.spaceId,
  });

  factory UserModel.fromJson(Map<Object?, dynamic> json) {
    return UserModel(
      email: json['email'],
      id: json['id'],
      role: UserRole.fromValue(json['role']),
      spaceId: json['spaceId'],
    );
  }

  final String email;
  final String id;
  final UserRole role;
  final String? spaceId;

  Map<String, dynamic> toJson() => {
        'email': email,
        'id': id,
        'role': role.value,
        'spaceId': spaceId,
      };
}
