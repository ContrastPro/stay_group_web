import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/users/user_info_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/companies_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'manage_company_event.dart';

part 'manage_company_state.dart';

class ManageCompanyBloc extends Bloc<ManageCompanyEvent, ManageCompanyState> {
  ManageCompanyBloc({
    required this.authRepository,
    required this.companiesRepository,
    required this.usersRepository,
  }) : super(const ManageCompanyState()) {
    on<CreateCompany>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final User? user = authRepository.currentUser();

      final UserModel? response = await usersRepository.getUserById(
        userId: user!.uid,
      );

      final String spaceId = response!.info.role == UserRole.manager
          ? response.userId!
          : response.spaceId!;

      final String id = uuid();

      await companiesRepository.createCompany(
        spaceId: spaceId,
        id: id,
        name: event.name,
        description: event.description,
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

    on<UpdateCompany>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final User? user = authRepository.currentUser();

      final UserModel? response = await usersRepository.getUserById(
        userId: user!.uid,
      );

      final String spaceId = response!.info.role == UserRole.manager
          ? response.userId!
          : response.spaceId!;

      await companiesRepository.updateCompanyInfo(
        spaceId: spaceId,
        id: event.id,
        name: event.name,
        description: event.description,
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
  final CompaniesRepository companiesRepository;
  final UsersRepository usersRepository;
}
