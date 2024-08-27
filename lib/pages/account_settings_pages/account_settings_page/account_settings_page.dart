import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/auth_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_text_styles.dart';
import '../../../utils/constants.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/flexible_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import 'blocs/account_settings_bloc/account_settings_bloc.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({
    super.key,
    required this.state,
  });

  static const routePath = '/account_settings_pages/account_settings';

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountSettingsBloc>(
      create: (_) => AccountSettingsBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const Init(),
        ),
      child: FlexibleLayout(
        state: state,
        builder: (Size size) {
          return BlocConsumer<AccountSettingsBloc, AccountSettingsState>(
            listener: (_, state) {
              //
            },
            builder: (context, state) {
              if (state.status == BlocStatus.success) {
                return FadeInAnimation(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Account info',
                        style: AppTextStyles.paragraphMBold,
                      ),
                      Text(
                        '${state.userData!.info.name} - ${state.userData!.info.role.value}',
                      ),
                      Text(
                        state.userData!.credential.email,
                      ),
                      const SizedBox(height: 32.0),
                      Text(
                        'User space',
                        style: AppTextStyles.paragraphMBold,
                      ),
                      Text(
                        '${state.userData!.spaceId}',
                      ),
                      const SizedBox(height: 32.0),
                      SizedBox(
                        width: 260.0,
                        child: CustomButton(
                          text: 'Sign out',
                          onTap: () => context.read<AccountSettingsBloc>().add(
                                const SignOut(),
                              ),
                        ),
                      ),
                    ],
                  ),
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
