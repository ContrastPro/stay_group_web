import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/users/user_info_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/projects_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'manage_project_event.dart';

part 'manage_project_state.dart';

class ManageProjectBloc extends Bloc<ManageProjectEvent, ManageProjectState> {
  ManageProjectBloc({
    required this.authRepository,
    required this.projectsRepository,
    required this.usersRepository,
  }) : super(const ManageProjectState()) {
    on<CreateProject>((event, emit) async {
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

      final String id = uuid();

      await projectsRepository.createProject(
        spaceId: spaceId,
        id: id,
        name: event.name,
        description: event.description,
      );

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
        ),
      );
    });

    on<UpdateProject>((event, emit) async {
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

      await projectsRepository.updateProjectInfo(
        spaceId: spaceId,
        id: event.id,
        name: event.name,
        description: event.description,
      );

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
        ),
      );
    });
  }

  final AuthRepository authRepository;
  final ProjectsRepository projectsRepository;
  final UsersRepository usersRepository;
}
