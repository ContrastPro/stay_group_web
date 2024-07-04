part of 'navigation_bloc.dart';

enum NavigationStatus { initial, auth, tab }

@immutable
class NavigationState {
  const NavigationState({
    this.status = NavigationStatus.initial,
    this.routePath = DashboardPage.routePath,
    this.authSubscription,
  });

  final NavigationStatus status;
  final String routePath;
  final StreamSubscription<User?>? authSubscription;

  NavigationState copyWith({
    NavigationStatus? status,
    String? routePath,
    StreamSubscription<User?>? authSubscription,
  }) {
    return NavigationState(
      status: status ?? this.status,
      routePath: routePath ?? this.routePath,
      authSubscription: authSubscription,
    );
  }
}
