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
    required this.id,
    required this.role,
    required this.email,
    this.spaceId,
    required this.name,
    required this.createdAt,
    this.dueDate,
    required this.isDeleted,
  });

  factory UserModel.fromJson(Map<Object?, dynamic> json) {
    return UserModel(
      id: json['id'],
      role: UserRole.fromValue(json['role']),
      email: json['email'],
      spaceId: json['spaceId'],
      name: json['name'],
      createdAt: json['createdAt'],
      dueDate: json['dueDate'],
      isDeleted: json['isDeleted'],
    );
  }

  final String id;
  final UserRole role;
  final String email;
  final String? spaceId;
  final String name;
  final String createdAt;
  final String? dueDate;
  final bool isDeleted;
}
