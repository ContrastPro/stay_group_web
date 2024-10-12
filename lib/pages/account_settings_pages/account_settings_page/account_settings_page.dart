import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/auth_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_text_styles.dart';
import '../../../services/in_app_notification_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/translate_locale.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/drawer_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/text_fields/custom_text_field.dart';
import '../../../widgets/views/table_view.dart';
import 'blocs/account_settings_bloc/account_settings_bloc.dart';

const TranslateLocale _locale = TranslateLocale(
  'account_settings.account_settings',
);

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({
    super.key,
    required this.state,
  });

  static const routePath = '/account_settings_pages/account_settings';

  final GoRouterState state;

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final TextEditingController _controllerWorkspace = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();

  bool _dataLoaded = false;
  bool _isLoading = false;
  bool _nameValid = false;

  String? _errorTextName;

  void _setInitialData(AccountSettingsState state) {
    if (_dataLoaded) return;

    if (state.spaceData != null) {
      _controllerWorkspace.text = state.spaceData!.info.name;
    }

    _controllerName.text = state.userData!.info.name;
    _validateName(state.userData!.info.name);
    _controllerEmail.text = state.userData!.credential.email;

    if (state.userData!.info.phone != null) {
      _controllerPhone.text = state.userData!.info.phone!;
    }

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

  void _updateAccountInfo({
    required BuildContext context,
    required AccountSettingsState state,
  }) {
    _switchErrorName();

    final String name = _controllerName.text.trim();
    final String phone = _controllerPhone.text.trim();

    if (name.isEmpty || !_nameValid) {
      final String errorName = _locale.tr(
        state.spaceData != null ? 'name_short' : 'workspace_name_short',
      );

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    context.read<AccountSettingsBloc>().add(
          UpdateAccountInfo(
            name: name,
            phone: phone,
          ),
        );
  }

  void _switchErrorName({String? error}) {
    setState(() => _errorTextName = error);
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
    return BlocProvider<AccountSettingsBloc>(
      create: (_) => AccountSettingsBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const Init(),
        ),
      child: DrawerLayout(
        state: widget.state,
        builder: (Size size) {
          return BlocConsumer<AccountSettingsBloc, AccountSettingsState>(
            listener: (_, state) {
              if (state.userData != null) {
                _setInitialData(state);
              }

              if (state.status == BlocStatus.loading) {
                _switchLoading(true);
              }

              if (state.status == BlocStatus.loaded) {
                _switchLoading(false);
              }

              if (state.status == BlocStatus.success) {
                InAppNotificationService.show(
                  title: _locale.tr('profile_updated'),
                  type: InAppNotificationType.success,
                );
              }
            },
            builder: (context, state) {
              if (_dataLoaded) {
                return FadeInAnimation(
                  child: ActionLoader(
                    isLoading: _isLoading,
                    child: TableView(
                      screenSize: size,
                      header: SizedBox(
                        height: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _locale.tr('account_settings'),
                              style: AppTextStyles.head6Medium,
                            ),
                          ],
                        ),
                      ),
                      body: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 360.0,
                                child: Column(
                                  children: [
                                    if (state.spaceData != null) ...[
                                      CustomTextField(
                                        controller: _controllerWorkspace,
                                        enabled: false,
                                        labelText: _locale.tr('workspace_name'),
                                      ),
                                      const SizedBox(height: 16.0),
                                    ],
                                    CustomTextField(
                                      controller: _controllerName,
                                      enabled: state.spaceData == null,
                                      labelText: _locale.tr('name'),
                                      hintText: _locale.tr('workspace_name'),
                                      errorText: _errorTextName,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(64),
                                      ],
                                      onChanged: _validateName,
                                    ),
                                    const SizedBox(height: 16.0),
                                    CustomTextField(
                                      controller: _controllerEmail,
                                      enabled: false,
                                      labelText: _locale.tr('email'),
                                    ),
                                    const SizedBox(height: 16.0),
                                    CustomTextField(
                                      controller: _controllerPhone,
                                      labelText: _locale.tr('phone'),
                                      hintText: _locale.tr('contact_phone'),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\+?\d{0,15}$'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 40.0),
                                    CustomButton(
                                      text: _locale.tr('save_changes'),
                                      onTap: () => _updateAccountInfo(
                                        context: context,
                                        state: state,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
