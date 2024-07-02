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
    required this.index,
    required this.routePath,
  });

  final int index;
  final String routePath;
}
