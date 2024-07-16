import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../repositories/auth_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
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
                  state: state,
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
    required this.state,
    required this.navigateToManageUserPage,
  });

  final TeamState state;
  final void Function() navigateToManageUserPage;

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      duration: kFadeInDuration,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
          vertical: 32.0,
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 130.0,
                    child: CustomButton(
                      text: 'Create user',
                      onTap: navigateToManageUserPage,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
             Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Customer Full Name',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Email',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Role',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Date Joined',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (_, int i) {
                  return SizedBox(
                    height: 50.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            state.users[i].info.name,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            state.users[i].info.email,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            state.users[i].info.role.value,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            utcToLocal(
                              state.users[i].metadata.createdAt,
                              format: DateFormat(
                                'dd/MM/yy',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
