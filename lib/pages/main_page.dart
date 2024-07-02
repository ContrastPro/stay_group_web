import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/navigation_bloc/navigation_bloc.dart';
import '../repositories/auth_repository.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.state,
    required this.body,
    required this.navigateToLogInPage,
    required this.onSelectTab,
  });

  final GoRouterState state;
  final Widget body;
  final void Function() navigateToLogInPage;
  final void Function(String) onSelectTab;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (_) => NavigationBloc(
            authRepository: context.read<AuthRepository>(),
          )..add(
              const StartSubscription(),
            ),
        ),
      ],
      child: BlocConsumer<NavigationBloc, NavigationState>(
        listener: (_, state) {
          if (state.status == NavigationStatus.auth) {
            navigateToLogInPage();
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
