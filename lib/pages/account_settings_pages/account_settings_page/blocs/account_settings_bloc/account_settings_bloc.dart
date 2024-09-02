import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/users/user_info_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'account_settings_event.dart';

part 'account_settings_state.dart';

class AccountSettingsBloc
    extends Bloc<AccountSettingsEvent, AccountSettingsState> {
  AccountSettingsBloc({
    required this.authRepository,
    required this.usersRepository,
  }) : super(const AccountSettingsState()) {
    on<Init>((event, emit) async {
      await requestDelay();

      final User? user = authRepository.currentUser();

      final UserModel? response = await usersRepository.getUserById(
        userId: user!.uid,
      );

      final String spaceId = response!.info.role == UserRole.manager
          ? response.userId!
          : response.spaceId!;

      final UserModel? spaceData;

      if (response.info.role == UserRole.manager) {
        spaceData = null;
      } else {
        spaceData = await usersRepository.getUserById(
          userId: spaceId,
        );
      }

      emit(
        state.copyWith(
          userData: response,
          spaceData: spaceData,
        ),
      );
    });

    on<UpdateAccountInfo>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      await usersRepository.updateUserInfo(
        id: state.userData!.id,
        role: state.userData!.info.role,
        name: event.name,
        billingPlan: state.userData!.info.billingPlan,
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
