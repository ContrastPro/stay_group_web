class UserInfoModel {
  const UserInfoModel({
    required this.email,
    required this.id,
  });

  factory UserInfoModel.fromJson(Map<Object?, dynamic> json) {
    return UserInfoModel(
      email: json['email'],
      id: json['id'],
    );
  }

  final String email;
  final String id;

  Map<String, dynamic> toJson() => {
        'email': email,
        'id': id,
      };
}
