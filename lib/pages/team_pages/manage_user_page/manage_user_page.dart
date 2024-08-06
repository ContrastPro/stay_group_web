import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/auth_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../resources/app_text_styles.dart';
import '../../../services/in_app_notification_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/layouts/manage_preview_layout.dart';
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
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _isLoading = false;
  bool _nameValid = false;
  bool _emailValid = false;
  bool _isObscurePassword = true;
  bool _passwordValid = false;

  String? _errorTextName;
  String? _errorTextEmail;
  String? _errorTextPassword;

  void _switchLoading(bool status) {
    if (_isLoading != status) {
      setState(() => _isLoading = status);
    }
  }

  void _validateName(String name) {
    setState(() {
      _nameValid = name.length > 2;
    });
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

  void _switchErrorName({String? error}) {
    setState(() => _errorTextName = error);
  }

  void _switchErrorEmail({String? error}) {
    setState(() => _errorTextEmail = error);
  }

  void _switchErrorPassword({String? error}) {
    setState(() => _errorTextPassword = error);
  }

  void _createUser(BuildContext context) {
    _switchErrorName();
    _switchErrorEmail();
    _switchErrorPassword();

    final String name = _controllerName.text.trim();
    final String email = _controllerEmail.text.trim();
    final String password = _controllerPassword.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'User name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

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
          CreateUser(
            name: name,
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
                type: InAppNotificationType.success,
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
              child: ManagePreviewLayout(
                content: Column(
                  children: [
                    Text(
                      'Add New Member',
                      style: AppTextStyles.head5SemiBold,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Create your team member.',
                      style: AppTextStyles.paragraphSRegular.copyWith(
                        color: AppColors.iconPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28.0),
                    BorderTextField(
                      controller: _controllerName,
                      labelText: 'Name',
                      hintText: 'User name',
                      prefixIcon: AppIcons.user,
                      errorText: _errorTextName,
                      onChanged: _validateName,
                    ),
                    const SizedBox(height: 16.0),
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
                    const SizedBox(height: 40.0),
                    CustomButton(
                      text: 'Create user',
                      onTap: () => _createUser(context),
                    ),
                    const SizedBox(height: 12.0),
                    CustomTextButton(
                      prefixIcon: AppIcons.arrowBack,
                      text: 'Back to Team page',
                      onTap: widget.navigateToTeamPage,
                    ),
                  ],
                ),
                preview: SizedBox(
                  width: 360.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 120.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          gradient: AppColors.userGradient,
                        ),
                      ),
                      Container(
                        height: 4.0,
                        color: AppColors.border,
                      ),
                      Container(
                        height: 100.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.scaffoldSecondary,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                getFirstLetter(
                                  _controllerName.text.isNotEmpty
                                      ? _controllerName.text
                                      : 'User Name',
                                ),
                                style:
                                    AppTextStyles.paragraphMSemiBold.copyWith(
                                  color: AppColors.scaffoldSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      _controllerName.text.isNotEmpty
                                          ? _controllerName.text
                                          : 'User Name',
                                      style: AppTextStyles.paragraphMRegular,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      _controllerEmail.text.isNotEmpty
                                          ? _controllerEmail.text
                                          : '@placeholder.com',
                                      style: AppTextStyles.paragraphSRegular,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}