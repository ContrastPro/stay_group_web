part of 'navigation_bloc.dart';

enum NavigationStatus { initial, auth, pricing, tab }

@immutable
class NavigationState {
  const NavigationState({
    this.status = NavigationStatus.initial,
    this.routePath = DashboardPage.routePath,
    this.errorMessage,
    this.user,
    this.timerDueDate,
    this.authSubscription,
  });

  final NavigationStatus status;
  final String routePath;
  final String? errorMessage;
  final UserModel? user;
  final Timer? timerDueDate;
  final StreamSubscription<User?>? authSubscription;

  NavigationState copyWith({
    NavigationStatus? status,
    String? routePath,
    String? errorMessage,
    UserModel? user,
    Timer? timerDueDate,
    StreamSubscription<User?>? authSubscription,
  }) {
    return NavigationState(
      status: status ?? this.status,
      routePath: routePath ?? this.routePath,
      errorMessage: errorMessage,
      user: user,
      timerDueDate: timerDueDate,
      authSubscription: authSubscription,
    );
  }
}
