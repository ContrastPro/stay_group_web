import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/navigation_bloc/navigation_bloc.dart';
import '../routes/app_router.dart';
import 'building_companies_pages/building_companies_page/building_companies_pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const routeName = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _onSelectTab(String route) {
    if (_navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushNamedAndRemoveUntil(
        route,
        (_) => false,
      );
    }
  }

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
            _onSelectTab(state.route);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Navigator(
              key: _navigatorKey,
              initialRoute: BuildingCompaniesPage.routeName,
              onGenerateRoute: AppRouter.generateRoute,
            ),
          );
        },
      ),
    );
  }
}
