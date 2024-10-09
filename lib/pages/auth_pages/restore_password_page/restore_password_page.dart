import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
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
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/layouts/container_layout.dart';
import '../../../widgets/text_fields/custom_text_field.dart';

class RestorePasswordPage extends StatefulWidget {
  const RestorePasswordPage({
    super.key,
    required this.navigateToRestoreEmailPage,
    required this.navigateToLogInPage,
  });

  static const routePath = '/auth_pages/restore_password';

  final void Function(String) navigateToRestoreEmailPage;
  final void Function() navigateToLogInPage;

  @override
  State<RestorePasswordPage> createState() => _RestorePasswordPageState();
}

class _RestorePasswordPageState extends State<RestorePasswordPage> {
  final TextEditingController _controllerEmail = TextEditingController();

  bool _isLoading = false;
  bool _emailValid = false;

  String? _errorText;

  void _switchLoading(bool status) {
    if (_isLoading != status) {
      setState(() => _isLoading = status);
    }
  }

  void _validateEmail(String email) {
    setState(() {
      _emailValid = EmailValidator.validate(email);
    });
  }

  void _passwordRecovery(BuildContext context) {
    _switchError();

    final String email = _controllerEmail.text.trim();

    if (email.isEmpty || !_emailValid) {
      const String errorFormat = 'Wrong email format';

      _switchError(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    context.read<AuthBloc>().add(
          PasswordRecovery(
            email: email,
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
            widget.navigateToRestoreEmailPage(
              _controllerEmail.text.trim(),
            );
          }

          if (state.status == BlocStatus.failed) {
            _switchError(error: state.errorMessage);
            _showErrorMessage(errorMessage: state.errorMessage!);
          }
        },
        builder: (context, _) {
          return ActionLoader(
            isLoading: _isLoading,
            child: ContainerLayout(
              body: Column(
                children: [
                  AutoSizeText(
                    'Reset your password',
                    style: AppTextStyles.head5SemiBold,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Enter your email, and we'll help ou reset it in snap. Security made simple",
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
                    onChanged: _validateEmail,
                  ),
                  const SizedBox(height: 40.0),
                  CustomButton(
                    text: 'Reset password',
                    onTap: () => _passwordRecovery(context),
                  ),
                  const SizedBox(height: 12.0),
                  CustomTextButton(
                    prefixIcon: AppIcons.arrowBack,
                    text: 'Back to Log in',
                    onTap: widget.navigateToLogInPage,
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
