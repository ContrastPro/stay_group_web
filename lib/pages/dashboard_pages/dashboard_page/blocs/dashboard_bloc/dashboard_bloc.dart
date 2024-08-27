import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/companies/company_model.dart';
import '../../../../../models/companies/company_response_model.dart';
import '../../../../../models/users/user_info_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/companies_repository.dart';
import '../../../../../repositories/storage_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required this.authRepository,
    required this.companiesRepository,
    required this.storageRepository,
    required this.usersRepository,
  }) : super(const DashboardState()) {
    on<Init>((event, emit) async {
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

      final List<CompanyModel> companies = [];

      final CompanyResponseModel? savedCompanies =
          await companiesRepository.getCompanies(spaceId: spaceId);

      if (savedCompanies != null) {
        companies.addAll(savedCompanies.companies);

        companies.sort(
          (a, b) => b.metadata.createdAt.compareTo(a.metadata.createdAt),
        );
      }

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
          companies: companies,
        ),
      );
    });

    on<DeleteCompany>((event, emit) async {
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

      final List<CompanyModel> companies = [...state.companies];

      final int index = companies.indexWhere(
        (e) => e.id == event.id,
      );

      if (companies[index].info.media != null) {
        for (int i = 0; i < companies[index].info.media!.length; i++) {
          await storageRepository.deleteMedia(
            isThumbnail: false,
            spaceId: spaceId,
            id: companies[index].info.media![i].id,
          );

          await storageRepository.deleteMedia(
            isThumbnail: true,
            spaceId: spaceId,
            id: companies[index].info.media![i].id,
          );
        }
      }

      await companiesRepository.deleteCompany(
        spaceId: spaceId,
        id: event.id,
      );

      companies.removeAt(index);

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
          companies: companies,
        ),
      );
    });
  }

  final AuthRepository authRepository;
  final CompaniesRepository companiesRepository;
  final StorageRepository storageRepository;
  final UsersRepository usersRepository;
}
