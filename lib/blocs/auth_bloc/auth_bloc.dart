import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/users/user_info_model.dart';
import '../../models/users/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/users_repository.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authRepository,
    required this.usersRepository,
  }) : super(const AuthState()) {
    on<EmailLogIn>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final UserCredential? response = await authRepository.emailLogIn(
        email: event.email,
        password: event.password,
      );

      if (response != null) {
        final UserModel? userData = await usersRepository.getUserById(
          userId: response.user!.uid,
        );

        if (userData!.info.role == UserRole.manager) {
          if (response.user!.emailVerified) {
            emit(
              state.copyWith(
                status: BlocStatus.loaded,
              ),
            );

            return emit(
              state.copyWith(
                status: BlocStatus.success,
              ),
            );
          }

          await authRepository.signOut();

          emit(
            state.copyWith(
              status: BlocStatus.loaded,
            ),
          );

          return emit(
            state.copyWith(
              status: BlocStatus.failed,
              errorMessage:
                  'The email address is not verified. Check your mailbox',
            ),
          );
        }

        emit(
          state.copyWith(
            status: BlocStatus.loaded,
          ),
        );

        return emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      }

      final UserModel? userData = await usersRepository.getUserByEmail(
        email: event.email,
      );

      if (userData != null) {
        if (userData.userId != null) {
          emit(
            state.copyWith(
              status: BlocStatus.loaded,
            ),
          );

          return emit(
            state.copyWith(
              status: BlocStatus.failed,
              errorMessage: 'The email or password is incorrect',
            ),
          );
        }

        final bool passwordValid = passwordIsValid(
          cryptPassword: userData.credential.presignedPassword!,
          enterPassword: event.password,
        );

        if (passwordValid) {
          final UserCredential? credential = await authRepository.emailSignUp(
            email: event.email,
            password: event.password,
          );

          await usersRepository.activateUser(
            id: userData.id,
            userId: credential!.user!.uid,
            email: userData.credential.email,
          );

          emit(
            state.copyWith(
              status: BlocStatus.loaded,
            ),
          );

          return emit(
            state.copyWith(
              status: BlocStatus.success,
            ),
          );
        }

        emit(
          state.copyWith(
            status: BlocStatus.loaded,
          ),
        );

        return emit(
          state.copyWith(
            status: BlocStatus.failed,
            errorMessage: 'The email or password is incorrect',
          ),
        );
      }

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      return emit(
        state.copyWith(
          status: BlocStatus.failed,
          errorMessage: 'The email or password is incorrect',
        ),
      );
    });

    on<EmailSignUp>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final UserCredential? response = await authRepository.emailSignUp(
        email: event.email,
        password: event.password,
      );

      if (response != null) {
        final User user = response.user!;

        final String id = uuid();

        final DateTime dueDate = currentTime().add(
          const Duration(days: 3),
        );

        await usersRepository.createUser(
          id: id,
          userId: user.uid,
          email: user.email!,
          role: UserRole.manager,
          name: 'My space',
          dueDate: dueDate,
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

      await requestDelay();

      final UserModel? response = await usersRepository.getUserByEmail(
        email: event.email,
      );

      if (response == null) {
        emit(
          state.copyWith(
            status: BlocStatus.loaded,
          ),
        );

        return emit(
          state.copyWith(
            status: BlocStatus.failed,
            errorMessage: 'User with this email does not exist',
          ),
        );
      }

      if (response.userId == null) {
        emit(
          state.copyWith(
            status: BlocStatus.loaded,
          ),
        );

        return emit(
          state.copyWith(
            status: BlocStatus.failed,
            errorMessage: 'User with this email does not exist',
          ),
        );
      }

      final bool? isSent = await authRepository.passwordRecovery(
        email: event.email,
      );

      if (isSent != null) {
        emit(
          state.copyWith(
            status: BlocStatus.loaded,
          ),
        );

        return emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      }

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.failed,
          errorMessage: 'User with this email does not exist',
        ),
      );
    });
  }

  final AuthRepository authRepository;
  final UsersRepository usersRepository;
}
