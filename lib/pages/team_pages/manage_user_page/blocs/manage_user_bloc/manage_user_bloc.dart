import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../database/local_database.dart';
import '../../../../../models/users/auth_data_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';

part 'manage_user_event.dart';

part 'manage_user_state.dart';

class ManageUserBloc extends Bloc<ManageUserEvent, ManageUserState> {
  ManageUserBloc({
    required this.authRepository,
    required this.usersRepository,
    required this.localDB,
  }) : super(const ManageUserState()) {
    on<CreateWorker>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      final User? userData = authRepository.currentUser();

      final UserCredential? createdWorker = await authRepository.emailSignUp(
        email: event.email,
        password: event.password,
      );

      if (createdWorker != null) {
        final User worker = createdWorker.user!;

        await usersRepository.createUser(
          userId: worker.uid,
          spaceId: userData!.uid,
          role: UserRole.worker,
          email: worker.email!,
        );

        await authRepository.sendEmailVerification();

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
