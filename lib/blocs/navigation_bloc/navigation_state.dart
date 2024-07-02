part of 'navigation_bloc.dart';

enum NavigationStatus { initial, auth, tab }

@immutable
class NavigationState {
  const NavigationState({
    this.status = NavigationStatus.initial,
    this.currentTab = 0,
    this.routePath = DashboardPage.routePath,
    this.authSubscription,
  });

  final NavigationStatus status;
  final int currentTab;
  final String routePath;
  final StreamSubscription<User?>? authSubscription;

  NavigationState copyWith({
    NavigationStatus? status,
    int? currentTab,
    String? routePath,
    StreamSubscription<User?>? authSubscription,
  }) {
    return NavigationState(
      status: status ?? this.status,
      currentTab: currentTab ?? this.currentTab,
      routePath: routePath ?? this.routePath,
      authSubscription: authSubscription,
    );
  }
}
