part of 'navigation_bloc.dart';

enum NavigationStatus { initial, tab }

@immutable
class NavigationState {
  const NavigationState({
    this.status = NavigationStatus.initial,
    this.currentTab = 0,
    this.route = BuildingCompaniesPage.routeName,
  });

  final NavigationStatus status;
  final int currentTab;
  final String route;

  NavigationState copyWith({
    NavigationStatus? status,
    int? currentTab,
    String? route,
  }) {
    return NavigationState(
      status: status ?? this.status,
      currentTab: currentTab ?? this.currentTab,
      route: route ?? this.route,
    );
  }
}
