import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/users/user_model.dart';
import '../../pages/dashboard_pages/dashboard_page/dashboard_pages.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/users_repository.dart';
import '../../services/timer_service.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc({
    required this.authRepository,
    required this.usersRepository,
    required this.timerService,
  }) : super(const NavigationState()) {
    on<StartSubscription>((event, emit) async {
      final Timer timerDueDate = timerService.startTimer(
        addInitialTick: true,
        tick: const Duration(
          milliseconds: 10000,
        ),
        onTick: () => add(
          const DueDateTick(),
        ),
      );

      final StreamSubscription<User?> authChanges = authRepository.authChanges(
        navigateToLogInPage: () {
          return add(
            const NavigateLogin(),
          );
        },
      );

      emit(
        state.copyWith(
          timerDueDate: timerDueDate,
          authSubscription: authChanges,
        ),
      );
    });

    on<DueDateTick>((event, emit) async {
      final User? user = authRepository.currentUser();

      if (user == null) {
        return add(
          const NavigateLogin(),
        );
      }

      final int difference;

      final UserModel? userData = await usersRepository.getUser(
        userId: user.uid,
      );

      if (userData!.spaceId != null) {
        final UserModel? spaseData = await usersRepository.getUser(
          userId: userData.spaceId!,
        );

        difference = dateDifference(
          spaseData!.dueDate!,
          type: DateDifference.minutes,
        );
      } else {
        difference = dateDifference(
          userData.dueDate!,
          type: DateDifference.minutes,
        );
      }

      if (difference < 0) {
        return add(
          const NavigatePricing(),
        );
      }
    });

    on<NavigateLogin>((event, emit) async {
      if (state.timerDueDate != null) {
        state.timerDueDate!.cancel();
      }

      if (state.authSubscription != null) {
        await state.authSubscription!.cancel();
      }

      emit(
        state.copyWith(
          status: NavigationStatus.auth,
        ),
      );
    });

    on<NavigatePricing>((event, emit) async {
      if (state.timerDueDate != null) {
        state.timerDueDate!.cancel();
      }

      if (state.authSubscription != null) {
        await state.authSubscription!.cancel();
      }

      await authRepository.signOut();

      emit(
        state.copyWith(
          status: NavigationStatus.auth,
        ),
      );
    });

    on<NavigateTab>((event, emit) {
      emit(
        state.copyWith(
          status: NavigationStatus.tab,
          routePath: event.routePath,
          timerDueDate: state.timerDueDate,
          authSubscription: state.authSubscription,
        ),
      );
    });
  }

  final TimerService timerService;
  final AuthRepository authRepository;
  final UsersRepository usersRepository;
}
