part of 'navigation_bloc.dart';

enum NavigationStatus { initial, tab }

@immutable
class NavigationState {
  const NavigationState({
    this.status = NavigationStatus.initial,
    this.currentTab = 0,
    this.routePath = DashboardPage.routePath,
  });

  final NavigationStatus status;
  final int currentTab;
  final String routePath;

  NavigationState copyWith({
    NavigationStatus? status,
    int? currentTab,
    String? routePath,
  }) {
    return NavigationState(
      status: status ?? this.status,
      currentTab: currentTab ?? this.currentTab,
      routePath: routePath ?? this.routePath,
    );
  }
}
