part of 'manage_project_bloc.dart';

@immutable
abstract class ManageProjectEvent {
  const ManageProjectEvent();
}

class CreateProject extends ManageProjectEvent {
  const CreateProject({
    required this.media,
    required this.name,
    required this.location,
    required this.description,
  });

  final List<MediaResponseModel> media;
  final String name;
  final String location;
  final String description;
}

class UpdateProject extends ManageProjectEvent {
  const UpdateProject({
    required this.id,
    required this.savedMedia,
    required this.addedMedia,
    required this.removedMedia,
    required this.name,
    required this.location,
    required this.description,
    required this.createdAt,
  });

  final String id;
  final List<MediaModel> savedMedia;
  final List<MediaResponseModel> addedMedia;
  final List<MediaModel> removedMedia;
  final String name;
  final String location;
  final String description;
  final String createdAt;
}
