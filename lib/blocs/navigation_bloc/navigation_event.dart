part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {
  const NavigationEvent();
}

class StartSubscription extends NavigationEvent {
  const StartSubscription();
}

class NavigateLogin extends NavigationEvent {
  const NavigateLogin();
}

class NavigateTab extends NavigationEvent {
  const NavigateTab({
    required this.routePath,
  });

  final String routePath;
}
