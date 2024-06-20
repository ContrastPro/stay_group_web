part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {
  const NavigationEvent();
}

class NavigateTab extends NavigationEvent {
  const NavigateTab({
    required this.index,
    required this.route,
  });

  final int index;
  final String route;
}
