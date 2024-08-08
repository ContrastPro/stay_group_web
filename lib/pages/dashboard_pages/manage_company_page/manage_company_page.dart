import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/companies/company_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/companies_repository.dart';
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
import 'blocs/manage_company_bloc/manage_company_bloc.dart';

class ManageCompanyPage extends StatefulWidget {
  const ManageCompanyPage({
    super.key,
    this.company,
    required this.navigateToDashboardPage,
  });

  static const routePath = '/dashboard_pages/manage_company';

  final CompanyModel? company;
  final void Function() navigateToDashboardPage;

  @override
  State<ManageCompanyPage> createState() => _ManageCompanyPageState();
}

class _ManageCompanyPageState extends State<ManageCompanyPage> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  bool _isLoading = false;
  bool _nameValid = false;
  bool _descriptionValid = false;

  String? _errorTextName;
  String? _errorTextDescription;

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    if (widget.company != null) {
      _controllerName.text = widget.company!.info.name;
      _validateName(widget.company!.info.name);
      _controllerDescription.text = widget.company!.info.description;
      _validateDescription(widget.company!.info.description);
    }
  }

  void _switchLoading(bool status) {
    if (_isLoading != status) {
      setState(() => _isLoading = status);
    }
  }

  void _validateName(String name) {
    setState(() {
      _nameValid = name.length > 1;
    });
  }

  void _validateDescription(String description) {
    setState(() {
      _descriptionValid = description.length > 1;
    });
  }

  void _switchErrorName({String? error}) {
    setState(() => _errorTextName = error);
  }

  void _switchErrorDescription({String? error}) {
    setState(() => _errorTextDescription = error);
  }

  void _createCompany(BuildContext context) {
    _switchErrorName();
    _switchErrorDescription();

    final String name = _controllerName.text.trim();
    final String description = _controllerDescription.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Company name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    if (description.isEmpty || !_descriptionValid) {
      const String errorFormat = 'Company description is too short';

      _switchErrorDescription(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    context.read<ManageCompanyBloc>().add(
          CreateCompany(
            name: name,
            description: description,
          ),
        );
  }

  void _updateCompany(BuildContext context) {
    _switchErrorName();
    _switchErrorDescription();

    final String name = _controllerName.text.trim();
    final String description = _controllerDescription.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Company name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    if (description.isEmpty || !_descriptionValid) {
      const String errorFormat = 'Company description is too short';

      _switchErrorDescription(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    context.read<ManageCompanyBloc>().add(
          UpdateCompany(
            id: widget.company!.id,
            name: name,
            description: description,
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
    return BlocProvider<ManageCompanyBloc>(
      create: (_) => ManageCompanyBloc(
        authRepository: context.read<AuthRepository>(),
        companiesRepository: context.read<CompaniesRepository>(),
        usersRepository: context.read<UsersRepository>(),
      ),
      child: Scaffold(
        body: BlocConsumer<ManageCompanyBloc, ManageCompanyState>(
          listener: (_, state) {
            if (state.status == BlocStatus.loading) {
              _switchLoading(true);
            }

            if (state.status == BlocStatus.loaded) {
              _switchLoading(false);
            }

            if (state.status == BlocStatus.success) {
              InAppNotificationService.show(
                title: widget.company == null
                    ? 'Company successfully created'
                    : 'Company successfully updated',
                type: InAppNotificationType.success,
              );

              widget.navigateToDashboardPage();
            }
          },
          builder: (context, state) {
            return ActionLoader(
              isLoading: _isLoading,
              child: ManagePreviewLayout(
                content: Column(
                  children: [
                    Text(
                      widget.company == null
                          ? 'Add new company'
                          : 'Edit company',
                      style: AppTextStyles.head5SemiBold,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.company == null
                          ? 'Create your company'
                          : 'Edit your company info',
                      style: AppTextStyles.paragraphSRegular.copyWith(
                        color: AppColors.iconPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28.0),
                    BorderTextField(
                      controller: _controllerName,
                      labelText: 'Name',
                      hintText: 'Company name',
                      prefixIcon: AppIcons.user,
                      errorText: _errorTextName,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(128),
                      ],
                      onChanged: _validateName,
                    ),
                    const SizedBox(height: 16.0),
                    BorderTextField(
                      controller: _controllerDescription,
                      labelText: 'Description',
                      hintText: 'Company description',
                      prefixIcon: AppIcons.mail,
                      errorText: _errorTextDescription,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4096),
                      ],
                      onChanged: _validateDescription,
                    ),
                    const SizedBox(height: 40.0),
                    if (widget.company == null) ...[
                      CustomButton(
                        text: 'Create company',
                        onTap: () => _createCompany(context),
                      ),
                    ] else ...[
                      CustomButton(
                        text: 'Save changes',
                        onTap: () => _updateCompany(context),
                      ),
                    ],
                    const SizedBox(height: 12.0),
                    CustomTextButton(
                      prefixIcon: AppIcons.arrowBack,
                      text: 'Back to Dashboard page',
                      onTap: widget.navigateToDashboardPage,
                    ),
                  ],
                ),
                preview: _CompanyPreview(
                  name: _controllerName.text,
                  description: _controllerDescription.text,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CompanyPreview extends StatelessWidget {
  const _CompanyPreview({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              horizontal: 16.0,
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
                      name.isNotEmpty ? name : 'Company Name',
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
                      Flexible(
                        child: Text(
                          name.isNotEmpty ? name : 'Company Name',
                          style: AppTextStyles.paragraphMRegular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          description.isNotEmpty
                              ? description
                              : 'Company description',
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
    );
  }
}
