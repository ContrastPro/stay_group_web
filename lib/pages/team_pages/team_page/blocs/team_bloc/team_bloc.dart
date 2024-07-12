import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';

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

      final User? user = authRepository.currentUser();

      if (user == null) {
        emit(
          state.copyWith(
            status: BlocStatus.loaded,
          ),
        );

        return emit(
          state.copyWith(
            status: BlocStatus.failed,
          ),
        );
      }

      await usersRepository.getTeam(spaceId: user.uid);

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
  final UsersRepository usersRepository;
}
