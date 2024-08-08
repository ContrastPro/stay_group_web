part of 'manage_project_bloc.dart';

@immutable
abstract class ManageProjectEvent {
  const ManageProjectEvent();
}

class CreateProject extends ManageProjectEvent {
  const CreateProject({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

class UpdateProject extends ManageProjectEvent {
  const UpdateProject({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;
}
