import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/local_database.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/users_repository.dart';
import '../../utils/constants.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authRepository,
    required this.usersRepository,
    required this.localDB,
  }) : super(const AuthState()) {
    on<EmailLogIn>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      final UserCredential? response = await authRepository.emailLogIn(
        email: event.email,
        password: event.password,
      );

      if (response != null) {
        if (response.user!.emailVerified) {
          await localDB.saveCurrentAuth(
            email: event.email,
            password: event.password,
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
          await authRepository.signOut();

          emit(
            state.copyWith(
              status: BlocStatus.loaded,
            ),
          );

          emit(
            state.copyWith(
              status: BlocStatus.failed,
              errorMessage:
                  'The email address is not verified. Check your mailbox',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.loaded,
          ),
        );

        emit(
          state.copyWith(
            status: BlocStatus.failed,
            errorMessage: 'The email or password is incorrect',
          ),
        );
      }
    });

    on<EmailSignUp>((event, emit) async {
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

        await authRepository.sendEmailVerification();

        await authRepository.signOut();

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

    on<PasswordRecovery>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      final bool? response = await authRepository.passwordRecovery(
        email: event.email,
      );

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      if (response != null) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.failed,
            errorMessage: 'User with this email does not exist',
          ),
        );
      }
    });
  }

  final AuthRepository authRepository;
  final UsersRepository usersRepository;
  final LocalDB localDB;
}
