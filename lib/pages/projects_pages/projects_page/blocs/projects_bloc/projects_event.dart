part of 'projects_bloc.dart';

@immutable
abstract class ProjectsEvent {
  const ProjectsEvent();
}

class GetProjects extends ProjectsEvent {
  const GetProjects();
}

class DeleteProject extends ProjectsEvent {
  const DeleteProject({
    required this.id,
  });

  final String id;
}
