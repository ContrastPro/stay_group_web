part of 'projects_bloc.dart';

@immutable
abstract class ProjectsEvent {
  const ProjectsEvent();
}

class Init extends ProjectsEvent {
  const Init();
}

class DeleteProject extends ProjectsEvent {
  const DeleteProject({
    required this.id,
  });

  final String id;
}
