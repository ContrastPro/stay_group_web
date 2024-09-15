import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/calculations/calculation_model.dart';
import '../../../../../models/calculations/calculation_response_model.dart';
import '../../../../../models/users/user_info_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/calculations_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'calculations_event.dart';

part 'calculations_state.dart';

class CalculationsBloc extends Bloc<CalculationsEvent, CalculationsState> {
  CalculationsBloc({
    required this.authRepository,
    required this.calculationsRepository,
    required this.usersRepository,
  }) : super(const CalculationsState()) {
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

      final List<CalculationModel> calculations = [];

      final CalculationResponseModel? savedCalculations =
          await calculationsRepository.getCalculations(spaceId: spaceId);

      if (savedCalculations != null) {
        calculations.addAll(savedCalculations.calculations);

        calculations.sort(
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
          userData: response,
          calculations: calculations,
        ),
      );
    });

    on<DeleteCalculation>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

      final String spaceId = state.userData!.info.role == UserRole.manager
          ? state.userData!.userId!
          : state.userData!.spaceId!;

      final List<CalculationModel> calculations = [...state.calculations];

      final int index = calculations.indexWhere(
        (e) => e.id == event.id,
      );

      await calculationsRepository.deleteCalculation(
        spaceId: spaceId,
        id: event.id,
      );

      calculations.removeAt(index);

      calculations.sort(
        (a, b) => b.metadata.createdAt.compareTo(a.metadata.createdAt),
      );

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
          calculations: calculations,
        ),
      );
    });
  }

  final AuthRepository authRepository;
  final CalculationsRepository calculationsRepository;
  final UsersRepository usersRepository;
}
