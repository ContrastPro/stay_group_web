import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/navigation_bloc/navigation_bloc.dart';
import '../repositories/auth_repository.dart';
import '../repositories/users_repository.dart';
import '../services/in_app_notification_service.dart';
import '../services/timer_service.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.state,
    required this.body,
    required this.navigateToLogInPage,
    required this.navigateToPricingPage,
    required this.onSelectTab,
  });

  final GoRouterState state;
  final Widget body;
  final void Function() navigateToLogInPage;
  final void Function() navigateToPricingPage;
  final void Function(String) onSelectTab;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (_) => NavigationBloc(
            timerService: TimerService.instance,
            authRepository: context.read<AuthRepository>(),
            usersRepository: context.read<UsersRepository>(),
          )..add(
              const StartSubscription(),
            ),
        ),
      ],
      child: BlocConsumer<NavigationBloc, NavigationState>(
        listener: (_, state) {
          if (state.errorMessage != null) {
            InAppNotificationService.show(
              title: state.errorMessage!,
              type: InAppNotificationType.error,
            );
          }

          if (state.status == NavigationStatus.auth) {
            navigateToLogInPage();
          }

          if (state.status == NavigationStatus.pricing) {
            navigateToPricingPage();
          }

          if (state.status == NavigationStatus.tab) {
            onSelectTab(state.routePath);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: body,
          );
        },
      ),
    );
  }
}
