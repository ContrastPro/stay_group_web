class UserMetadataModel {
  const UserMetadataModel({
    required this.createdAt,
    this.dueDate,
  });

  factory UserMetadataModel.fromJson(Map<Object?, dynamic> json) {
    return UserMetadataModel(
      createdAt: json['createdAt'],
      dueDate: json['dueDate'],
    );
  }

  final String createdAt;
  final String? dueDate;
}
