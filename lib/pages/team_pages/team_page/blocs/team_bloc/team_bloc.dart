import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/users/user_model.dart';
import '../../../../../models/users/user_response_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'team_event.dart';

part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  TeamBloc({
    required this.authRepository,
    required this.usersRepository,
  }) : super(const TeamState()) {
    on<GetUsers>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final User? user = authRepository.currentUser();

      final List<UserModel> users = [];

      final UserResponseModel? response = await usersRepository.getUserTeam(
        spaceId: user!.uid,
      );

      if (response != null) {
        users.addAll(response.users);

        users.sort(
          (a, b) => b.metadata.createdAt.compareTo(a.metadata.createdAt),
        );
      }

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
          users: users,
        ),
      );
    });

    on<DeleteUser>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final UserModel? response = await usersRepository.getUserByEmail(
        email: event.email,
      );

      if (response!.userId != null) {
        return add(
          const GetUsers(),
        );
      }

      final List<UserModel> users = [...state.users];

      final int index = users.indexWhere(
        (e) => e.id == event.id,
      );

      await usersRepository.deleteUser(
        id: event.id,
      );

      users.removeAt(index);

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
          users: users,
        ),
      );
    });

    on<SwitchUserArchive>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final List<UserModel> users = [...state.users];

      final int index = users.indexWhere(
        (e) => e.id == event.id,
      );

      await usersRepository.updateUserArchive(
        id: event.id,
        archived: event.archived,
      );

      users[index] = users[index].copyWith(
        archived: event.archived,
      );

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
          users: users,
        ),
      );
    });
  }

  final AuthRepository authRepository;
  final UsersRepository usersRepository;
}
