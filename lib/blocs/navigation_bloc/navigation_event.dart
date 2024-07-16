part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {
  const NavigationEvent();
}

class StartSubscription extends NavigationEvent {
  const StartSubscription();
}

class DueDateTick extends NavigationEvent {
  const DueDateTick();
}

class StopSubscription extends NavigationEvent {
  const StopSubscription({
    required this.status,
    this.errorMessage,
  });

  final NavigationStatus status;
  final String? errorMessage;
}

class NavigateTab extends NavigationEvent {
  const NavigateTab({
    required this.routePath,
  });

  final String routePath;
}
