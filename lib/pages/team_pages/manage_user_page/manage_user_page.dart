import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/users/user_info_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../resources/app_text_styles.dart';
import '../../../services/in_app_notification_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../utils/translate_locale.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/custom_icon_button.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/layouts/preview_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/text_fields/custom_text_field.dart';
import 'blocs/manage_user_bloc/manage_user_bloc.dart';

const TranslateLocale _locale = TranslateLocale('team.manage_user');

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
  State<ManageUserPage> createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _dataLoaded = false;
  bool _isLoading = false;
  bool _nameValid = false;
  bool _emailValid = false;
  bool _isObscurePassword = true;
  bool _passwordValid = false;

  String? _errorTextName;
  String? _errorTextEmail;
  String? _errorTextPassword;

  void _setInitialData(ManageUserState state) {
    if (_dataLoaded) return;

    if (state.userData == null) {
      return _switchDataLoaded(true);
    }

    final UserInfoModel info = state.userData!.info;

    _controllerName.text = info.name;
    _validateName(info.name);
    _controllerEmail.text = state.userData!.credential.email;

    _switchDataLoaded(true);
  }

  void _switchDataLoaded(bool status) {
    if (_dataLoaded != status) {
      setState(() => _dataLoaded = status);
    }
  }

  void _switchLoading(bool status) {
    if (_isLoading != status) {
      setState(() => _isLoading = status);
    }
  }

  void _validateName(String name) {
    setState(() => _nameValid = name.length > 1);
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

  void _createUser({
    required BuildContext context,
    required ManageUserState state,
  }) {
    _switchErrorName();
    _switchErrorEmail();
    _switchErrorPassword();

    if (state.users.length > 3) {
      final String errorLimit = _locale.tr('limit_reached');
      return _showErrorMessage(errorMessage: errorLimit);
    }

    final String name = _controllerName.text.trim();
    final String email = _controllerEmail.text.trim();
    final String password = _controllerPassword.text.trim();

    if (name.isEmpty || !_nameValid) {
      final String errorName = _locale.tr('name_short');

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

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

    context.read<ManageUserBloc>().add(
          CreateUser(
            name: name,
            email: email,
            password: password,
          ),
        );
  }

  void _updateUser(BuildContext context) {
    _switchErrorName();

    final String name = _controllerName.text.trim();

    if (name.isEmpty || !_nameValid) {
      final String errorName = _locale.tr('name_short');

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    context.read<ManageUserBloc>().add(
          UpdateUser(
            name: name,
          ),
        );
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
      )..add(
          Init(
            id: widget.id,
          ),
        ),
      child: BlocConsumer<ManageUserBloc, ManageUserState>(
        listener: (_, state) {
          if (state.user != null) {
            _setInitialData(state);
          }

          if (state.status == BlocStatus.loading) {
            _switchLoading(true);
            _switchErrorEmail();
          }

          if (state.status == BlocStatus.loaded) {
            _switchLoading(false);
          }

          if (state.status == BlocStatus.success) {
            InAppNotificationService.show(
              title: _locale.tr(
                state.userData == null ? 'user_created' : 'user_updated',
              ),
              type: InAppNotificationType.success,
            );

            if (state.userData == null) {
              widget.navigateToTeamPage();
            }
          }

          if (state.status == BlocStatus.failed) {
            _switchErrorEmail(error: state.errorMessage);
            _showErrorMessage(errorMessage: state.errorMessage!);
          }
        },
        builder: (context, state) {
          if (_dataLoaded) {
            return ActionLoader(
              isLoading: _isLoading,
              child: PreviewLayout(
                content: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIconButton(
                        icon: AppIcons.arrowBack,
                        iconColor: AppColors.primary,
                        backgroundColor: AppColors.scaffoldSecondary,
                        splashColor: AppColors.scaffoldPrimary,
                        onTap: widget.navigateToTeamPage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    _locale.tr(
                      state.userData == null ? 'add_member' : 'edit_member',
                    ),
                    style: AppTextStyles.head5SemiBold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _locale.tr(
                      state.userData == null
                          ? 'create_team_member'
                          : 'edit_team_member',
                    ),
                    style: AppTextStyles.paragraphSRegular.copyWith(
                      color: AppColors.iconPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28.0),
                  CustomTextField(
                    controller: _controllerName,
                    labelText: _locale.tr('name'),
                    hintText: _locale.tr('user_name'),
                    prefixIcon: AppIcons.user,
                    errorText: _errorTextName,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(64),
                    ],
                    onChanged: _validateName,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    controller: _controllerEmail,
                    enabled: state.userData == null,
                    labelText: _locale.tr('email'),
                    hintText: _locale.tr('user_email'),
                    prefixIcon: AppIcons.mail,
                    errorText: _errorTextEmail,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(64),
                    ],
                    onChanged: _validateEmail,
                  ),
                  if (state.userData == null) ...[
                    const SizedBox(height: 16.0),
                    CustomTextField(
                      controller: _controllerPassword,
                      labelText: _locale.tr('password'),
                      hintText: _locale.tr('user_password'),
                      isObscureText: _isObscurePassword,
                      prefixIcon: AppIcons.lock,
                      suffixIcon: _isObscurePassword
                          ? AppIcons.visibilityOff
                          : AppIcons.visibilityOn,
                      errorText: _errorTextPassword,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(32),
                      ],
                      onSuffixTap: _switchObscurePassword,
                      onChanged: _validatePassword,
                    ),
                    const SizedBox(height: 40.0),
                    CustomButton(
                      text: _locale.tr('create_user'),
                      onTap: () => _createUser(
                        context: context,
                        state: state,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 40.0),
                    CustomButton(
                      text: _locale.tr('save_changes'),
                      onTap: () => _updateUser(context),
                    ),
                  ],
                  const SizedBox(height: 12.0),
                  CustomTextButton(
                    prefixIcon: AppIcons.arrowBack,
                    text: _locale.tr('back_team'),
                    onTap: widget.navigateToTeamPage,
                  ),
                ],
                preview: _UserPreview(
                  name: _controllerName.text,
                  email: _controllerEmail.text,
                ),
              ),
            );
          }

          return const Center(
            child: CustomLoader(),
          );
        },
      ),
    );
  }
}

class _UserPreview extends StatelessWidget {
  const _UserPreview({
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 32.0,
      ),
      constraints: const BoxConstraints(
        minWidth: 512.0,
        maxWidth: 512.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.scaffoldSecondary,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            height: 144.0,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
              gradient: AppColors.backgroundGradient,
            ),
          ),
          Container(
            height: 4.0,
            color: AppColors.border,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 28.0,
              horizontal: 22.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    getFirstLetter(
                      name.isNotEmpty ? name : _locale.tr('user_name'),
                    ),
                    style: AppTextStyles.subtitleMedium.copyWith(
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
                      Text(
                        name.isNotEmpty ? name : _locale.tr('user_name'),
                        style: AppTextStyles.paragraphLMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        email.isNotEmpty ? email : '@placeholder.com',
                        style: AppTextStyles.paragraphMRegular,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
