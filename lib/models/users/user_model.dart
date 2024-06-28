import 'user_info_model.dart';

class UserModel {
  const UserModel({
    required this.info,
  });

  factory UserModel.fromJson(Map<Object?, dynamic> json) {
    return UserModel(
      info: UserInfoModel.fromJson(
        json['info'],
      ),
    );
  }

  final UserInfoModel info;

  Map<String, dynamic> toJson() => {
        'info': info.toJson(),
      };
}
