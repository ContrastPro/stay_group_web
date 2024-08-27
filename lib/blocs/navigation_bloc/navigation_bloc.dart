import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

      final UserModel? response = await usersRepository.getUserById(
        userId: user.uid,
      );

      final StreamSubscription<DatabaseEvent> userChanges;
      final StreamSubscription<DatabaseEvent>? spaceChanges;
      final Timer timerDueDate;

      if (response!.info.role == UserRole.manager) {
        userChanges = usersRepository.userChanges(
          id: response.id,
          userUpdates: (UserModel event) {
            add(
              CheckUserStatus(
                userData: event,
              ),
            );
          },
        );

        spaceChanges = null;

        timerDueDate = timerService.startTimer(
          addInitialTick: true,
          onTick: () => add(
            DueDateTick(
              userData: response,
            ),
          ),
        );
      } else {
        userChanges = usersRepository.userChanges(
          id: response.id,
          userUpdates: (UserModel event) {
            add(
              CheckUserStatus(
                userData: event,
              ),
            );
          },
        );

        final UserModel? spaceData = await usersRepository.getUserById(
          userId: response.spaceId!,
        );

        spaceChanges = usersRepository.userChanges(
          id: spaceData!.id,
          userUpdates: (UserModel event) {
            add(
              CheckUserStatus(
                userData: event,
              ),
            );
          },
        );

        timerDueDate = timerService.startTimer(
          addInitialTick: true,
          onTick: () => add(
            DueDateTick(
              userData: spaceData,
            ),
          ),
        );
      }

      final StreamSubscription<User?> authChanges = authRepository.authChanges(
        navigateToLogInPage: () {
          return add(
            const StopSubscription(
              status: NavigationStatus.auth,
            ),
          );
        },
      );

      emit(
        state.copyWith(
          userData: response,
          userSubscription: userChanges,
          spaceSubscription: spaceChanges,
          timerDueDate: timerDueDate,
          authSubscription: authChanges,
        ),
      );
    });

    on<CheckUserStatus>((event, emit) async {
      if (event.userData.archived) {
        return add(
          const StopSubscription(
            status: NavigationStatus.auth,
            errorMessage:
                'You have been logged out due to account archived or deleted',
          ),
        );
      }

      if (event.userData.blocked) {
        return add(
          const StopSubscription(
            status: NavigationStatus.auth,
            errorMessage: 'You have been logged out due to account blocking',
          ),
        );
      }
    });

    on<DueDateTick>((event, emit) async {
      final int difference = dateDifference(
        event.userData.metadata.dueDate!,
        type: DateDifference.minutes,
      );

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
      if (state.userSubscription != null) {
        await state.userSubscription!.cancel();
      }

      if (state.spaceSubscription != null) {
        await state.spaceSubscription!.cancel();
      }

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
          userData: state.userData,
          userSubscription: state.userSubscription,
          spaceSubscription: state.spaceSubscription,
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
