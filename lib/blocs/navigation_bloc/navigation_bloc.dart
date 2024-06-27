import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pages/dashboard_pages/dashboard_page/dashboard_pages.dart';

part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateTab>((event, emit) {
      emit(
        state.copyWith(
          status: NavigationStatus.tab,
          currentTab: event.index,
          routePath: event.routePath,
        ),
      );
    });
  }
}
