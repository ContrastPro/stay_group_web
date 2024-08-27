part of 'navigation_bloc.dart';

enum NavigationStatus { initial, auth, pricing, tab }

@immutable
class NavigationState {
  const NavigationState({
    this.status = NavigationStatus.initial,
    this.routePath = DashboardPage.routePath,
    this.errorMessage,
    this.userData,
    this.userSubscription,
    this.spaceSubscription,
    this.timerDueDate,
    this.authSubscription,
  });

  final NavigationStatus status;
  final String routePath;
  final String? errorMessage;
  final UserModel? userData;
  final StreamSubscription<DatabaseEvent>? userSubscription;
  final StreamSubscription<DatabaseEvent>? spaceSubscription;
  final Timer? timerDueDate;
  final StreamSubscription<User?>? authSubscription;

  NavigationState copyWith({
    NavigationStatus? status,
    String? routePath,
    String? errorMessage,
    UserModel? userData,
    StreamSubscription<DatabaseEvent>? userSubscription,
    StreamSubscription<DatabaseEvent>? spaceSubscription,
    Timer? timerDueDate,
    StreamSubscription<User?>? authSubscription,
  }) {
    return NavigationState(
      status: status ?? this.status,
      routePath: routePath ?? this.routePath,
      errorMessage: errorMessage,
      userData: userData,
      userSubscription: userSubscription,
      spaceSubscription: spaceSubscription,
      timerDueDate: timerDueDate,
      authSubscription: authSubscription,
    );
  }
}
