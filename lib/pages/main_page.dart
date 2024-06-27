import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/navigation_bloc/navigation_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.pageBuilder,
    required this.onSelectTab,
  });

  final StatefulNavigationShell pageBuilder;
  final void Function(String) onSelectTab;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (_) => NavigationBloc(),
        ),
      ],
      child: BlocConsumer<NavigationBloc, NavigationState>(
        listener: (_, state) {
          if (state.status == NavigationStatus.tab) {
            onSelectTab(state.routePath);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: pageBuilder,
          );
        },
      ),
    );
  }
}
