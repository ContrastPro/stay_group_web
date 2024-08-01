import 'user_credential_model.dart';
import 'user_info_model.dart';
import 'user_metadata_model.dart';

class UserModel {
  const UserModel({
    required this.archived,
    required this.blocked,
    required this.id,
    this.userId,
    this.spaceId,
    required this.credential,
    required this.info,
    required this.metadata,
  });

  factory UserModel.fromJson(Map<Object?, dynamic> json) {
    return UserModel(
      archived: json['archived'],
      blocked: json['blocked'],
      id: json['id'],
      userId: json['userId'],
      spaceId: json['spaceId'],
      credential: UserCredentialModel.fromJson(json['credential']),
      info: UserInfoModel.fromJson(json['info']),
      metadata: UserMetadataModel.fromJson(json['metadata']),
    );
  }

  final bool archived;
  final bool blocked;
  final String id;
  final String? userId;
  final String? spaceId;
  final UserCredentialModel credential;
  final UserInfoModel info;
  final UserMetadataModel metadata;

  UserModel copyWith({
    bool? archived,
    bool? blocked,
    String? id,
    String? userId,
    String? spaceId,
    UserCredentialModel? credential,
    UserInfoModel? info,
    UserMetadataModel? metadata,
  }) {
    return UserModel(
      archived: archived ?? this.archived,
      blocked: blocked ?? this.blocked,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      spaceId: spaceId ?? this.spaceId,
      credential: credential ?? this.credential,
      info: info ?? this.info,
      metadata: metadata ?? this.metadata,
    );
  }
}
