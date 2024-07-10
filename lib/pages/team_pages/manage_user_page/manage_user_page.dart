import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../database/local_database.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_icons.dart';
import '../../../services/in_app_notification_service.dart';
import '../../../utils/constants.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/text_fields/border_text_field.dart';
import 'blocs/manage_user_bloc/manage_user_bloc.dart';

class ManageUserPage extends StatefulWidget {
  const ManageUserPage({
    super.key,
    this.id,
    required this.navigateToTeamPage,
  });

  static const routePath = '/team_pages/manage_user';

  final String? id;
  final void Function() navigateToTeamPage;

  @override
  State<ManageUserPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<ManageUserPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _isLoading = false;
  bool _isObscurePassword = true;
  bool _emailValid = false;
  bool _passwordValid = false;

  String? _errorTextEmail;
  String? _errorTextPassword;

  void _switchLoading(bool status) {
    if (_isLoading != status) {
      setState(() => _isLoading = status);
    }
  }

  void _switchObscurePassword() {
    setState(() => _isObscurePassword = !_isObscurePassword);
  }

  void _switchErrorEmail({String? error}) {
    setState(() => _errorTextEmail = error);
  }

  void _switchErrorPassword({String? error}) {
    setState(() => _errorTextPassword = error);
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

  void _createWorker(BuildContext context) {
    _switchErrorEmail();
    _switchErrorPassword();

    final String email = _controllerEmail.text.trim();
    final String password = _controllerPassword.text.trim();

    if (email.isEmpty || !_emailValid) {
      const String errorFormat = 'Wrong email format';

      _switchErrorEmail(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    if (password.isEmpty || !_passwordValid) {
      const String errorLength = 'User password is too short';

      _switchErrorPassword(error: errorLength);
      return _showErrorMessage(errorMessage: errorLength);
    }

    context.read<ManageUserBloc>().add(
          CreateWorker(
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
    return BlocProvider<ManageUserBloc>(
      create: (_) => ManageUserBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
        localDB: LocalDB.instance,
      ),
      child: Scaffold(
        body: BlocConsumer<ManageUserBloc, ManageUserState>(
          listener: (_, state) {
            if (state.status == BlocStatus.loading) {
              _switchLoading(true);
              _switchErrorEmail();
            }

            if (state.status == BlocStatus.loaded) {
              _switchLoading(false);
            }

            if (state.status == BlocStatus.success) {
              InAppNotificationService.show(
                title: 'User successfully created!',
              );

              widget.navigateToTeamPage();
            }

            if (state.status == BlocStatus.failed) {
              _switchErrorEmail(error: state.errorMessage);
              _showErrorMessage(errorMessage: state.errorMessage!);
            }
          },
          builder: (context, state) {
            return ActionLoader(
              isLoading: _isLoading,
              child: FadeInAnimation(
                duration: kFadeInDuration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 260.0,
                      child: Column(
                        children: [
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
                          CustomButton(
                            text: 'Create user',
                            onTap: () => _createWorker(context),
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
      ),
    );
  }
}
