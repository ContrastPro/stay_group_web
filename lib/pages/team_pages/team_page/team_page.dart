import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/auth_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../utils/constants.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/flexible_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import 'blocs/team_bloc/team_bloc.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({
    super.key,
    required this.state,
    required this.navigateToManageUserPage,
  });

  static const routePath = '/team_pages/team';

  final GoRouterState state;
  final void Function() navigateToManageUserPage;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamBloc>(
      create: (_) => TeamBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const GetUsers(),
        ),
      child: FlexibleLayout(
        state: widget.state,
        builder: (Size size) {
          return BlocBuilder<TeamBloc, TeamState>(
            builder: (context, state) {
              if (state.status == BlocStatus.success) {
                return _TeamPageContent(
                  navigateToManageUserPage: widget.navigateToManageUserPage,
                );
              }

              return const Center(
                child: CustomLoader(),
              );
            },
          );
        },
      ),
    );
  }
}

class _TeamPageContent extends StatelessWidget {
  const _TeamPageContent({
    required this.navigateToManageUserPage,
  });

  final void Function() navigateToManageUserPage;

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      duration: kFadeInDuration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 260.0,
            child: CustomButton(
              text: 'Create user',
              onTap: navigateToManageUserPage,
            ),
          ),
        ],
      ),
    );
  }
}
