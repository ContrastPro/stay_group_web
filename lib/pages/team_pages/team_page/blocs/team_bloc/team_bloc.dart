import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../database/local_database.dart';
import '../../../../../models/users/auth_data_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';

part 'team_event.dart';

part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  TeamBloc({
    required this.authRepository,
    required this.usersRepository,
    required this.localDB,
  }) : super(const TeamState()) {
    on<CreateEmailUser>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      final UserCredential? response = await authRepository.emailSignUp(
        email: event.email,
        password: event.password,
      );

      if (response != null) {
        final User user = response.user!;

        await usersRepository.createUser(
          email: user.email!,
          userId: user.uid,
        );

        final AuthDataModel? currentAuth = await localDB.getCurrentAuth();

        await authRepository.emailLogIn(
          email: currentAuth!.email,
          password: currentAuth.password,
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
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.loaded,
          ),
        );

        emit(
          state.copyWith(
            status: BlocStatus.failed,
            errorMessage: 'A user with this email address already exists',
          ),
        );
      }
    });
  }

  final AuthRepository authRepository;
  final UsersRepository usersRepository;
  final LocalDB localDB;
}
