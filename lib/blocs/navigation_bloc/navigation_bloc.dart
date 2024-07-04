import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pages/dashboard_pages/dashboard_page/dashboard_pages.dart';
import '../../repositories/auth_repository.dart';

part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc({
    required this.authRepository,
  }) : super(const NavigationState()) {
    on<StartSubscription>((event, emit) async {
      final User? user = authRepository.currentUser();

      if (user == null) {
        return add(
          const NavigateLogin(),
        );
      }

      final StreamSubscription<User?> subscription = authRepository.authChanges(
        navigateToLogInPage: () {
          return add(
            const NavigateLogin(),
          );
        },
      );

      emit(
        state.copyWith(
          authSubscription: subscription,
        ),
      );
    });

    on<NavigateLogin>((event, emit) async {
      if (state.authSubscription != null) {
        await state.authSubscription!.cancel();
      }

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
          authSubscription: state.authSubscription,
        ),
      );
    });
  }

  final AuthRepository authRepository;
}
