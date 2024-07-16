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

      final UserResponseModel? response = await usersRepository.getTeam(
        spaceId: user!.uid,
      );

      if (response != null) {
        users.addAll(response.users);
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
  }

  final AuthRepository authRepository;
  final UsersRepository usersRepository;
}
