import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/projects/project_model.dart';
import '../../../../../models/projects/project_response_model.dart';
import '../../../../../models/users/user_info_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/projects_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'projects_event.dart';

part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc({
    required this.authRepository,
    required this.projectsRepository,
    required this.usersRepository,
  }) : super(const ProjectsState()) {
    on<GetProjects>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final User? user = authRepository.currentUser();

      final UserModel? response = await usersRepository.getUserById(
        userId: user!.uid,
      );

      final String spaceId = response!.info.role == UserRole.manager
          ? response.userId!
          : response.spaceId!;

      final List<ProjectModel> projects = [];

      final ProjectResponseModel? savedProjects =
          await projectsRepository.getProjects(spaceId: spaceId);

      if (savedProjects != null) {
        projects.addAll(savedProjects.projects);
      }

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
          projects: projects,
        ),
      );
    });

    on<DeleteProject>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final User? user = authRepository.currentUser();

      final UserModel? response = await usersRepository.getUserById(
        userId: user!.uid,
      );

      final String spaceId = response!.info.role == UserRole.manager
          ? response.userId!
          : response.spaceId!;

      final List<ProjectModel> projects = [...state.projects];

      final int index = projects.indexWhere(
        (e) => e.id == event.id,
      );

      await projectsRepository.deleteProject(
        spaceId: spaceId,
        id: event.id,
      );

      projects.removeAt(index);

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
          projects: projects,
        ),
      );
    });
  }

  final AuthRepository authRepository;
  final ProjectsRepository projectsRepository;
  final UsersRepository usersRepository;
}