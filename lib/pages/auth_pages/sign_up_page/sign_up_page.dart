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
import '../../../utils/translate_locale.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/container_layout.dart';
import '../../../widgets/text_fields/custom_text_field.dart';

const TranslateLocale _locale = TranslateLocale('auth.sign_up');

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
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _isObscurePassword = true;
  bool _confirmValid = false;
  bool _isObscureConfirm = true;

  String? _errorTextEmail;
  String? _errorTextPassword;
  String? _errorTextConfirm;

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

  void _switchObscurePassword() {
    setState(() => _isObscurePassword = !_isObscurePassword);
  }

  void _validatePassword(String password) {
    setState(() {
      _passwordValid = password.length > 5;
    });
  }

  void _switchObscureConfirm() {
    setState(() => _isObscureConfirm = !_isObscureConfirm);
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
      final String errorFormat = _locale.tr('wrong_format');

      _switchErrorEmail(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    if (password.isEmpty || !_passwordValid) {
      final String errorLength = _locale.tr('password_short');

      _switchErrorPassword(error: errorLength);
      return _showErrorMessage(errorMessage: errorLength);
    }

    if (confirm.isEmpty || !_confirmValid) {
      final String errorMatch = _locale.tr('confirm_passwords_match');

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

  void _switchErrorEmail({String? error}) {
    setState(() => _errorTextEmail = error);
  }

  void _switchErrorPassword({String? error}) {
    setState(() => _errorTextPassword = error);
  }

  void _switchErrorConfirm({String? error}) {
    setState(() => _errorTextConfirm = error);
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
            child: ContainerLayout(
              body: Column(
                children: [
                  AutoSizeText(
                    _locale.tr('join_today'),
                    style: AppTextStyles.head5SemiBold,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _locale.tr('sign_up_today'),
                    style: AppTextStyles.paragraphSRegular.copyWith(
                      color: AppColors.iconPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28.0),
                  CustomTextField(
                    controller: _controllerEmail,
                    labelText: _locale.tr('email'),
                    hintText: _locale.tr('placeholder'),
                    prefixIcon: AppIcons.mail,
                    errorText: _errorTextEmail,
                    onChanged: _validateEmail,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    controller: _controllerPassword,
                    labelText: _locale.tr('password'),
                    hintText: _locale.tr('password'),
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
                  CustomTextField(
                    controller: _controllerConfirm,
                    labelText: _locale.tr('confirm_password'),
                    hintText: _locale.tr('confirm_password'),
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
                    text: _locale.tr('sign_up'),
                    onTap: () => _emailSignUp(context),
                  ),
                  const SizedBox(height: 40.0),
                  GestureDetector(
                    onTap: widget.navigateToLogInPage,
                    behavior: HitTestBehavior.opaque,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          _locale.tr('already_account'),
                          style: AppTextStyles.paragraphSMedium.copyWith(
                            color: AppColors.iconPrimary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          _locale.tr('log_in'),
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
