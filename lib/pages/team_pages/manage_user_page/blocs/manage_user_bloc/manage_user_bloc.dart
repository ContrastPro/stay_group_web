import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/users/user_info_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../models/users/user_response_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'manage_user_event.dart';

part 'manage_user_state.dart';

class ManageUserBloc extends Bloc<ManageUserEvent, ManageUserState> {
  ManageUserBloc({
    required this.authRepository,
    required this.usersRepository,
  }) : super(const ManageUserState()) {
    on<Init>((event, emit) async {
      await requestDelay();

      final User? user = authRepository.currentUser();

      UserModel? userData;
      final List<UserModel> users = [];

      final UserResponseModel? response = await usersRepository.getUserTeam(
        spaceId: user!.uid,
      );

      if (response != null) {
        users.addAll(response.users);

        userData = users.firstWhereOrNull(
          (e) => e.id == event.id,
        );
      }

      emit(
        state.copyWith(
          user: user,
          userData: userData,
          users: users,
        ),
      );
    });

    on<CreateUser>((event, emit) async {
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
        final String id = uuid();
        final String presignedPassword = cryptPassword(event.password);

        await usersRepository.createUser(
          id: id,
          spaceId: state.user!.uid,
          email: event.email,
          presignedPassword: presignedPassword,
          role: UserRole.worker,
          name: event.name,
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

      emit(
        state.copyWith(
          status: BlocStatus.failed,
          errorMessage: 'A user with this email address already exists',
        ),
      );
    });

    on<UpdateUser>((event, emit) async {
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
