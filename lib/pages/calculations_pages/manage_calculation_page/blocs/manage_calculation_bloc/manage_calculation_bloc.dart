import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/calculations/calculation_extra_model.dart';
import '../../../../../models/calculations/calculation_model.dart';
import '../../../../../models/calculations/calculation_response_model.dart';
import '../../../../../models/companies/company_model.dart';
import '../../../../../models/companies/company_response_model.dart';
import '../../../../../models/projects/project_model.dart';
import '../../../../../models/projects/project_response_model.dart';
import '../../../../../models/users/user_info_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/calculations_repository.dart';
import '../../../../../repositories/companies_repository.dart';
import '../../../../../repositories/projects_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'manage_calculation_event.dart';

part 'manage_calculation_state.dart';

class ManageCalculationBloc
    extends Bloc<ManageCalculationEvent, ManageCalculationState> {
  ManageCalculationBloc({
    required this.authRepository,
    required this.usersRepository,
    required this.companiesRepository,
    required this.projectsRepository,
    required this.calculationsRepository,
  }) : super(const ManageCalculationState()) {
    on<Init>((event, emit) async {
      await requestDelay();

      final User? user = authRepository.currentUser();

      final UserModel? response = await usersRepository.getUserById(
        userId: user!.uid,
      );

      final String spaceId = response!.info.role == UserRole.manager
          ? response.userId!
          : response.spaceId!;

      UserModel? spaceData;

      if (response.info.role == UserRole.worker) {
        spaceData = await usersRepository.getUserById(
          userId: spaceId,
        );
      }

      CalculationModel? calculation;
      final List<CompanyModel> companies = [];
      final List<ProjectModel> projects = [];
      final List<CalculationModel> calculations = [];

      final CompanyResponseModel? savedCompanies =
          await companiesRepository.getCompanies(spaceId: spaceId);

      final ProjectResponseModel? savedProjects =
          await projectsRepository.getProjects(spaceId: spaceId);

      final CalculationResponseModel? savedCalculations =
          await calculationsRepository.getCalculations(spaceId: spaceId);

      if (savedCompanies != null) {
        companies.addAll(savedCompanies.companies);

        companies.sort(
          (a, b) => b.metadata.createdAt.compareTo(a.metadata.createdAt),
        );
      }

      if (savedProjects != null) {
        projects.addAll(savedProjects.projects);

        projects.sort(
          (a, b) => b.metadata.createdAt.compareTo(a.metadata.createdAt),
        );
      }

      if (savedCalculations != null) {
        calculations.addAll(savedCalculations.calculations);

        calculation = calculations.firstWhereOrNull(
          (e) => e.id == event.id,
        );
      }

      emit(
        state.copyWith(
          userData: response,
          spaceData: spaceData,
          calculation: calculation,
          companies: companies,
          projects: projects,
          calculations: calculations,
        ),
      );
    });

    on<CreateCalculation>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final String spaceId = state.userData!.info.role == UserRole.manager
          ? state.userData!.userId!
          : state.userData!.spaceId!;

      final String id = uuid();

      await calculationsRepository.createCalculation(
        spaceId: spaceId,
        id: id,
        companyId: event.companyId,
        projectId: event.projectId,
        section: event.section.isNotEmpty ? event.section : null,
        floor: event.floor.isNotEmpty ? event.floor : null,
        number: event.number.isNotEmpty ? event.number : null,
        type: event.type.isNotEmpty ? event.type : null,
        rooms: event.rooms.isNotEmpty ? event.rooms : null,
        bathrooms: event.bathrooms.isNotEmpty ? event.bathrooms : null,
        total: event.total.isNotEmpty ? event.total : null,
        living: event.living.isNotEmpty ? event.living : null,
        name: event.name,
        description: event.description.isNotEmpty ? event.description : null,
        currency: event.currency,
        price: event.price.isNotEmpty ? event.price : null,
        depositVal: event.depositVal.isNotEmpty ? event.depositVal : null,
        depositPct: event.depositPct.isNotEmpty ? event.depositPct : null,
        period: event.period,
        startInstallments: event.startInstallments,
        endInstallments: event.endInstallments,
        extra: event.extra.isNotEmpty ? event.extra : null,
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

    on<UpdateCalculation>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final String spaceId = state.userData!.info.role == UserRole.manager
          ? state.userData!.userId!
          : state.userData!.spaceId!;

      await calculationsRepository.updateCalculation(
        spaceId: spaceId,
        id: state.calculation!.id,
        companyId: event.companyId,
        projectId: event.projectId,
        section: event.section.isNotEmpty ? event.section : null,
        floor: event.floor.isNotEmpty ? event.floor : null,
        number: event.number.isNotEmpty ? event.number : null,
        type: event.type.isNotEmpty ? event.type : null,
        rooms: event.rooms.isNotEmpty ? event.rooms : null,
        bathrooms: event.bathrooms.isNotEmpty ? event.bathrooms : null,
        total: event.total.isNotEmpty ? event.total : null,
        living: event.living.isNotEmpty ? event.living : null,
        name: event.name,
        description: event.description.isNotEmpty ? event.description : null,
        currency: event.currency,
        price: event.price.isNotEmpty ? event.price : null,
        depositVal: event.depositVal.isNotEmpty ? event.depositVal : null,
        depositPct: event.depositPct.isNotEmpty ? event.depositPct : null,
        period: event.period,
        startInstallments: event.startInstallments,
        endInstallments: event.endInstallments,
        extra: event.extra.isNotEmpty ? event.extra : null,
        createdAt: state.calculation!.metadata.createdAt,
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
  final CompaniesRepository companiesRepository;
  final ProjectsRepository projectsRepository;
  final CalculationsRepository calculationsRepository;
}
