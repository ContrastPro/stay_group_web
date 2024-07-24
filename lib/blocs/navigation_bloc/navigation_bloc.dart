import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/users/user_info_model.dart';
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
      await requestDelay();

      final User? user = authRepository.currentUser();

      if (user == null) {
        return add(
          const StopSubscription(
            status: NavigationStatus.auth,
          ),
        );
      }

      final Timer timerDueDate = timerService.startTimer(
        addInitialTick: true,
        tick: const Duration(
          milliseconds: 30000,
        ),
        onTick: () => add(
          DueDateTick(user: user),
        ),
      );

      final StreamSubscription<User?> authChanges = authRepository.authChanges(
        navigateToLogInPage: () {
          return add(
            const StopSubscription(
              status: NavigationStatus.auth,
            ),
          );
        },
      );

      final UserModel? userData = await usersRepository.getUser(
        userId: user.uid,
      );

      emit(
        state.copyWith(
          user: userData,
          timerDueDate: timerDueDate,
          authSubscription: authChanges,
        ),
      );
    });

    on<DueDateTick>((event, emit) async {
      final int difference;

      final UserModel? userData = await usersRepository.getUser(
        userId: event.user.uid,
      );

      if (userData!.archived) {
        return add(
          const StopSubscription(
            status: NavigationStatus.auth,
            errorMessage:
                'You have been logged out due to account archived or deleted',
          ),
        );
      }

      if (userData.info.role == UserRole.worker) {
        final UserModel? spaceData = await usersRepository.getUser(
          userId: userData.spaceId!,
        );

        if (spaceData!.blocked) {
          return add(
            const StopSubscription(
              status: NavigationStatus.auth,
              errorMessage: 'You have been logged out due to account blocking',
            ),
          );
        }

        difference = dateDifference(
          spaceData.metadata.dueDate!,
          type: DateDifference.minutes,
        );
      } else {
        if (userData.blocked) {
          return add(
            const StopSubscription(
              status: NavigationStatus.auth,
              errorMessage: 'You have been logged out due to account blocking',
            ),
          );
        }

        difference = dateDifference(
          userData.metadata.dueDate!,
          type: DateDifference.minutes,
        );
      }

      if (difference < 0) {
        return add(
          const StopSubscription(
            status: NavigationStatus.pricing,
            errorMessage: 'Your subscription is expired',
          ),
        );
      }
    });

    on<StopSubscription>((event, emit) async {
      if (state.timerDueDate != null) {
        state.timerDueDate!.cancel();
      }

      if (state.authSubscription != null) {
        await state.authSubscription!.cancel();
      }

      await authRepository.signOut();

      emit(
        state.copyWith(
          status: event.status,
          errorMessage: event.errorMessage,
        ),
      );
    });

    on<NavigateTab>((event, emit) {
      emit(
        state.copyWith(
          status: NavigationStatus.tab,
          routePath: event.routePath,
          user: state.user,
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
