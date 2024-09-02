import '../medias/media_model.dart';

enum UserRole {
  //admin('root_admin'),
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
    this.billingPlan,
    this.media,
    required this.name,
    this.phone,
  });

  factory UserInfoModel.fromJson(Map<Object?, dynamic> json) {
    return UserInfoModel(
      role: UserRole.fromValue(json['role']),
      billingPlan: json['billingPlan'],
      media: json['media'] != null
          ? (json['media'] as List).map((e) => MediaModel.fromJson(e)).toList()
          : null,
      name: json['name'],
      phone: json['phone'],
    );
  }

  final UserRole role;
  final int? billingPlan;
  final List<MediaModel>? media;
  final String name;
  final String? phone;
}
