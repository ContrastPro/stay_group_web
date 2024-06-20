import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pages/building_companies_pages/building_companies_page/building_companies_pages.dart';

part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateTab>((event, emit) {
      emit(
        state.copyWith(
          status: NavigationStatus.tab,
          currentTab: event.index,
          route: event.route,
        ),
      );
    });
  }
}
