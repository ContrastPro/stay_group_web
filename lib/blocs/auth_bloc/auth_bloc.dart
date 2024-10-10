import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/users/user_info_model.dart';
import '../../models/users/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/users_repository.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/translate_locale.dart';

part 'auth_event.dart';

part 'auth_state.dart';

const TranslateLocale _locale = TranslateLocale('system');

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
        final User user = response.user!;

        final UserModel? userData = await usersRepository.getUserById(
          userId: user.uid,
        );

        if (userData!.info.role == UserRole.manager) {
          if (user.emailVerified) {
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
              errorMessage: _locale.tr(
                'email_not_verified',
              ),
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
              errorMessage: _locale.tr(
                'email_password_incorrect',
              ),
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

          final User user = credential!.user!;

          await usersRepository.activateUser(
            archived: userData.archived,
            blocked: userData.blocked,
            id: userData.id,
            userId: user.uid,
            spaceId: userData.spaceId!,
            email: userData.credential.email,
            role: userData.info.role,
            name: userData.info.name,
            createdAt: userData.metadata.createdAt,
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
            errorMessage: _locale.tr(
              'email_password_incorrect',
            ),
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
          errorMessage: _locale.tr(
            'email_password_incorrect',
          ),
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

      final UserModel? response = await usersRepository.getUserByEmail(
        email: event.email,
      );

      if (response != null) {
        emit(
          state.copyWith(
            status: BlocStatus.loaded,
          ),
        );

        return emit(
          state.copyWith(
            status: BlocStatus.failed,
            errorMessage: _locale.tr(
              'user_exists',
            ),
          ),
        );
      }

      final UserCredential? credential = await authRepository.emailSignUp(
        email: event.email,
        password: event.password,
      );

      final User user = credential!.user!;

      final String id = uuid();

      final DateTime dueDate = currentTime().add(
        const Duration(days: 30),
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

      return emit(
        state.copyWith(
          status: BlocStatus.success,
        ),
      );
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
            errorMessage: _locale.tr(
              'user_not_exist',
            ),
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
            errorMessage: _locale.tr(
              'user_not_exist',
            ),
          ),
        );
      }

      await authRepository.passwordRecovery(
        email: event.email,
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
  final UsersRepository usersRepository;
}
