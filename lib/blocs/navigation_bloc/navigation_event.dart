part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {
  const NavigationEvent();
}

class StartSubscription extends NavigationEvent {
  const StartSubscription();
}

class NavigateLogin extends NavigationEvent {
  const NavigateLogin({
    this.errorMessage,
  });

  final String? errorMessage;
}

class DueDateTick extends NavigationEvent {
  const DueDateTick();
}

class NavigatePricing extends NavigationEvent {
  const NavigatePricing({
    this.errorMessage,
  });

  final String? errorMessage;
}

class NavigateTab extends NavigationEvent {
  const NavigateTab({
    required this.routePath,
  });

  final String routePath;
}
