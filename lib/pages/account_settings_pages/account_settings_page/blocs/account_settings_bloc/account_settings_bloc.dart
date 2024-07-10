import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';

part 'account_settings_event.dart';

part 'account_settings_state.dart';

class AccountSettingsBloc
    extends Bloc<AccountSettingsEvent, AccountSettingsState> {
  AccountSettingsBloc({
    required this.authRepository,
    required this.usersRepository,
  }) : super(const AccountSettingsState()) {
    on<GetAccountInfo>((event, emit) async {
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

      final UserModel? userData = await usersRepository.getUser(
        userId: user.uid,
      );

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      if (userData != null) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
            user: userData,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.failed,
          ),
        );
      }
    });

    on<SignOut>((event, emit) async {
      await authRepository.signOut();
    });
  }

  final AuthRepository authRepository;
  final UsersRepository usersRepository;
}
