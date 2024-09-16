import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../resources/app_text_styles.dart';
import '../../../services/in_app_notification_service.dart';
import '../../../utils/constants.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/center_container_layout.dart';
import '../../../widgets/text_fields/custom_text_field.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({
    super.key,
    required this.navigateToRestorePasswordPage,
    required this.navigateToDashboardPage,
    required this.navigateToSignUpPage,
  });

  static const routePath = '/auth_pages/log_in';

  final void Function() navigateToRestorePasswordPage;
  final void Function() navigateToDashboardPage;
  final void Function() navigateToSignUpPage;

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _isLoading = false;
  bool _isObscurePassword = true;

  String? _errorText;

  void _switchLoading(bool status) {
    if (_isLoading != status) {
      setState(() => _isLoading = status);
    }
  }

  void _switchObscurePassword() {
    setState(() => _isObscurePassword = !_isObscurePassword);
  }

  void _emailLogIn(BuildContext context) {
    final String email = _controllerEmail.text.trim();
    final String password = _controllerPassword.text.trim();

    if (email.isEmpty) return;
    if (password.isEmpty) return;

    context.read<AuthBloc>().add(
          EmailLogIn(
            email: email,
            password: password,
          ),
        );
  }

  void _switchError({String? error}) {
    setState(() => _errorText = error);
  }

  void _showErrorMessage({
    required String errorMessage,
  }) {
    InAppNotificationService.show(
      title: errorMessage,
      type: InAppNotificationType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
      ),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state.status == BlocStatus.loading) {
            _switchLoading(true);
            _switchError();
          }

          if (state.status == BlocStatus.loaded) {
            _switchLoading(false);
          }

          if (state.status == BlocStatus.success) {
            widget.navigateToDashboardPage();
          }

          if (state.status == BlocStatus.failed) {
            _switchError(error: state.errorMessage);
            _showErrorMessage(errorMessage: state.errorMessage!);
          }
        },
        builder: (context, _) {
          return ActionLoader(
            isLoading: _isLoading,
            child: CenterContainerLayout(
              body: Column(
                children: [
                  Text(
                    'Welcome back',
                    style: AppTextStyles.head5SemiBold,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Dive back into your world with a simple sign-in. Your next adventure awaits - let's get started!",
                    style: AppTextStyles.paragraphSRegular.copyWith(
                      color: AppColors.iconPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28.0),
                  CustomTextField(
                    controller: _controllerEmail,
                    labelText: 'Email',
                    hintText: 'Placeholder',
                    prefixIcon: AppIcons.mail,
                    errorText: _errorText,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    controller: _controllerPassword,
                    labelText: 'Password',
                    hintText: 'Password',
                    isObscureText: _isObscurePassword,
                    prefixIcon: AppIcons.lock,
                    suffixIcon: _isObscurePassword
                        ? AppIcons.visibilityOff
                        : AppIcons.visibilityOn,
                    errorText: _errorText,
                    onSuffixTap: _switchObscurePassword,
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: widget.navigateToRestorePasswordPage,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          'Forgot password?',
                          style: AppTextStyles.paragraphSMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  CustomButton(
                    text: 'Log in',
                    onTap: () => _emailLogIn(context),
                  ),
                  const SizedBox(height: 40.0),
                  GestureDetector(
                    onTap: widget.navigateToSignUpPage,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: AppTextStyles.paragraphSMedium.copyWith(
                            color: AppColors.iconPrimary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Register now!',
                          style: AppTextStyles.paragraphSMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
