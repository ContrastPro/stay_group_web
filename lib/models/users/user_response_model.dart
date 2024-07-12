import 'user_model.dart';

class UserResponseModel {
  const UserResponseModel({
    required this.users,
  });

  factory UserResponseModel.fromJson(Map<Object?, dynamic> json) {
    return UserResponseModel(
      users: json.values.map((e) => UserModel.fromJson(e)).toList(),
    );
  }

  final List<UserModel> users;
}
