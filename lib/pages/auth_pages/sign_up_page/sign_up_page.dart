import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../database/local_database.dart';
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
import '../../../widgets/text_fields/border_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    required this.navigateToVerifyEmailPage,
    required this.navigateToLogInPage,
  });

  static const routePath = '/auth_pages/sign_up';

  final void Function(String) navigateToVerifyEmailPage;
  final void Function() navigateToLogInPage;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirm = TextEditingController();

  bool _isLoading = false;
  bool _isObscurePassword = true;
  bool _isObscureConfirm = true;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _confirmValid = false;

  String? _errorTextEmail;
  String? _errorTextPassword;
  String? _errorTextConfirm;

  void _switchLoading(bool status) {
    if (_isLoading != status) {
      setState(() => _isLoading = status);
    }
  }

  void _switchObscurePassword() {
    setState(() => _isObscurePassword = !_isObscurePassword);
  }

  void _switchObscureConfirm() {
    setState(() => _isObscureConfirm = !_isObscureConfirm);
  }

  void _switchErrorEmail({String? error}) {
    setState(() => _errorTextEmail = error);
  }

  void _switchErrorPassword({String? error}) {
    setState(() => _errorTextPassword = error);
  }

  void _switchErrorConfirm({String? error}) {
    setState(() => _errorTextConfirm = error);
  }

  void _validateEmail(String email) {
    setState(() {
      _emailValid = EmailValidator.validate(email);
    });
  }

  void _validatePassword(String password) {
    setState(() {
      _passwordValid = password.length > 5;
    });
  }

  void _validateConfirm(String confirm) {
    final String password = _controllerPassword.text.trim();

    setState(() {
      _confirmValid = confirm == password;
    });
  }

  void _emailSignUp(BuildContext context) {
    _switchErrorEmail();
    _switchErrorPassword();
    _switchErrorConfirm();

    final String email = _controllerEmail.text.trim();
    final String password = _controllerPassword.text.trim();
    final String confirm = _controllerConfirm.text.trim();

    if (email.isEmpty || !_emailValid) {
      const String errorFormat = 'Wrong email format';

      _switchErrorEmail(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    if (password.isEmpty || !_passwordValid) {
      const String errorLength = 'Your password is too short';

      _switchErrorPassword(error: errorLength);
      return _showErrorMessage(errorMessage: errorLength);
    }

    if (confirm.isEmpty || !_confirmValid) {
      const String errorMatch = 'Confirm passwords do NOT match';

      _switchErrorConfirm(error: errorMatch);
      return _showErrorMessage(errorMessage: errorMatch);
    }

    context.read<AuthBloc>().add(
          EmailSignUp(
            email: email,
            password: password,
          ),
        );
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
        localDB: LocalDB.instance,
      ),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state.status == BlocStatus.loading) {
            _switchLoading(true);
            _switchErrorEmail();
          }

          if (state.status == BlocStatus.loaded) {
            _switchLoading(false);
          }

          if (state.status == BlocStatus.success) {
            widget.navigateToVerifyEmailPage(
              _controllerEmail.text.trim(),
            );
          }

          if (state.status == BlocStatus.failed) {
            _switchErrorEmail(error: state.errorMessage);
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
                    'Join us today',
                    style: AppTextStyles.head5SemiBold,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Sign up today and unlock a world of possibilities. Your adventure begins here.',
                    style: AppTextStyles.paragraphSRegular.copyWith(
                      color: AppColors.iconPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28.0),
                  BorderTextField(
                    controller: _controllerEmail,
                    labelText: 'Email',
                    hintText: 'Placeholder',
                    prefixIcon: AppIcons.mail,
                    errorText: _errorTextEmail,
                    onChanged: _validateEmail,
                  ),
                  const SizedBox(height: 16.0),
                  BorderTextField(
                    controller: _controllerPassword,
                    labelText: 'Password',
                    hintText: 'Password',
                    isObscureText: _isObscurePassword,
                    prefixIcon: AppIcons.lock,
                    suffixIcon: _isObscurePassword
                        ? AppIcons.visibilityOff
                        : AppIcons.visibilityOn,
                    errorText: _errorTextPassword,
                    onSuffixTap: _switchObscurePassword,
                    onChanged: _validatePassword,
                  ),
                  const SizedBox(height: 16.0),
                  BorderTextField(
                    controller: _controllerConfirm,
                    labelText: 'Confirm Password',
                    hintText: 'Confirm Password',
                    isObscureText: _isObscureConfirm,
                    prefixIcon: AppIcons.lock,
                    suffixIcon: _isObscureConfirm
                        ? AppIcons.visibilityOff
                        : AppIcons.visibilityOn,
                    errorText: _errorTextConfirm,
                    onSuffixTap: _switchObscureConfirm,
                    onChanged: _validateConfirm,
                  ),
                  const SizedBox(height: 40.0),
                  CustomButton(
                    text: 'Sign up',
                    onTap: () => _emailSignUp(context),
                  ),
                  const SizedBox(height: 40.0),
                  GestureDetector(
                    onTap: widget.navigateToLogInPage,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: AppTextStyles.paragraphSMedium.copyWith(
                            color: AppColors.iconPrimary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Log in',
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
