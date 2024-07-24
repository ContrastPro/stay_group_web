import 'user_info_model.dart';
import 'user_metadata_model.dart';

class UserModel {
  const UserModel({
    required this.archived,
    required this.blocked,
    required this.id,
    this.spaceId,
    required this.info,
    required this.metadata,
  });

  factory UserModel.fromJson(Map<Object?, dynamic> json) {
    return UserModel(
      archived: json['archived'],
      blocked: json['blocked'],
      id: json['id'],
      spaceId: json['spaceId'],
      info: UserInfoModel.fromJson(json['info']),
      metadata: UserMetadataModel.fromJson(json['metadata']),
    );
  }

  final bool archived;
  final bool blocked;
  final String id;
  final String? spaceId;
  final UserInfoModel info;
  final UserMetadataModel metadata;

  UserModel copyWith({
    bool? archived,
    bool? blocked,
    String? id,
    String? spaceId,
    UserInfoModel? info,
    UserMetadataModel? metadata,
  }) {
    return UserModel(
      archived: archived ?? this.archived,
      blocked: blocked ?? this.blocked,
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      info: info ?? this.info,
      metadata: metadata ?? this.metadata,
    );
  }
}
