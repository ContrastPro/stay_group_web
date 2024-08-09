import '../medias/media_model.dart';

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
    this.media,
  });

  factory UserInfoModel.fromJson(Map<Object?, dynamic> json) {
    return UserInfoModel(
      role: UserRole.fromValue(json['role']),
      name: json['name'],
      billingPlan: json['billingPlan'],
      media: json['media'] != null
          ? (json['media'] as List).map((e) => MediaModel.fromJson(e)).toList()
          : null,
    );
  }

  final UserRole role;
  final String name;
  final int? billingPlan;
  final List<MediaModel>? media;
}
