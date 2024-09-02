part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {
  const NavigationEvent();
}

class StartSubscription extends NavigationEvent {
  const StartSubscription();
}

class CheckUserStatus extends NavigationEvent {
  const CheckUserStatus({
    required this.userData,
  });

  final UserModel userData;
}

class DueDateTick extends NavigationEvent {
  const DueDateTick({
    required this.userData,
  });

  final UserModel userData;
}

class NavigateTab extends NavigationEvent {
  const NavigateTab({
    required this.routePath,
  });

  final String routePath;
}

class SignOut extends NavigationEvent {
  const SignOut();
}

class StopSubscription extends NavigationEvent {
  const StopSubscription({
    required this.status,
    this.errorMessage,
  });

  final NavigationStatus status;
  final String? errorMessage;
}
