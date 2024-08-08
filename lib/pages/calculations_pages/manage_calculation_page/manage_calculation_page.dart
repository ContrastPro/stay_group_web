import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/calculations/calculation_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/calculations_repository.dart';
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
import 'blocs/manage_calculation_bloc/manage_calculation_bloc.dart';

class ManageCalculationPage extends StatefulWidget {
  const ManageCalculationPage({
    super.key,
    this.calculation,
    required this.navigateToCalculationsPage,
  });

  static const routePath = '/calculations_pages/manage_calculation';

  final CalculationModel? calculation;
  final void Function() navigateToCalculationsPage;

  @override
  State<ManageCalculationPage> createState() => _ManageCalculationPageState();
}

class _ManageCalculationPageState extends State<ManageCalculationPage> {
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
    if (widget.calculation != null) {
      _controllerName.text = widget.calculation!.info.name;
      _validateName(widget.calculation!.info.name);
      _controllerDescription.text = widget.calculation!.info.description;
      _validateDescription(widget.calculation!.info.description);
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

  void _createCalculation(BuildContext context) {
    _switchErrorName();
    _switchErrorDescription();

    final String name = _controllerName.text.trim();
    final String description = _controllerDescription.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Calculation name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    if (description.isEmpty || !_descriptionValid) {
      const String errorFormat = 'Calculation description is too short';

      _switchErrorDescription(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    context.read<ManageCalculationBloc>().add(
          CreateCalculation(
            name: name,
            description: description,
          ),
        );
  }

  void _updateCalculation(BuildContext context) {
    _switchErrorName();
    _switchErrorDescription();

    final String name = _controllerName.text.trim();
    final String description = _controllerDescription.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Calculation name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    if (description.isEmpty || !_descriptionValid) {
      const String errorFormat = 'Calculation description is too short';

      _switchErrorDescription(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    context.read<ManageCalculationBloc>().add(
          UpdateCalculation(
            id: widget.calculation!.id,
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
    return BlocProvider<ManageCalculationBloc>(
      create: (_) => ManageCalculationBloc(
        authRepository: context.read<AuthRepository>(),
        calculationsRepository: context.read<CalculationsRepository>(),
        usersRepository: context.read<UsersRepository>(),
      ),
      child: Scaffold(
        body: BlocConsumer<ManageCalculationBloc, ManageCalculationState>(
          listener: (_, state) {
            if (state.status == BlocStatus.loading) {
              _switchLoading(true);
            }

            if (state.status == BlocStatus.loaded) {
              _switchLoading(false);
            }

            if (state.status == BlocStatus.success) {
              InAppNotificationService.show(
                title: widget.calculation == null
                    ? 'Calculation successfully created'
                    : 'Calculation successfully updated',
                type: InAppNotificationType.success,
              );

              widget.navigateToCalculationsPage();
            }
          },
          builder: (context, state) {
            return ActionLoader(
              isLoading: _isLoading,
              child: ManagePreviewLayout(
                content: Column(
                  children: [
                    Text(
                      widget.calculation == null
                          ? 'Add new calculation'
                          : 'Edit calculation',
                      style: AppTextStyles.head5SemiBold,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.calculation == null
                          ? 'Create your calculation'
                          : 'Edit your calculation info',
                      style: AppTextStyles.paragraphSRegular.copyWith(
                        color: AppColors.iconPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28.0),
                    BorderTextField(
                      controller: _controllerName,
                      labelText: 'Name',
                      hintText: 'Calculation name',
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
                      hintText: 'Calculation description',
                      prefixIcon: AppIcons.mail,
                      errorText: _errorTextDescription,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4096),
                      ],
                      onChanged: _validateDescription,
                    ),
                    const SizedBox(height: 40.0),
                    if (widget.calculation == null) ...[
                      CustomButton(
                        text: 'Create calculation',
                        onTap: () => _createCalculation(context),
                      ),
                    ] else ...[
                      CustomButton(
                        text: 'Save changes',
                        onTap: () => _updateCalculation(context),
                      ),
                    ],
                    const SizedBox(height: 12.0),
                    CustomTextButton(
                      prefixIcon: AppIcons.arrowBack,
                      text: 'Back to calculations page',
                      onTap: widget.navigateToCalculationsPage,
                    ),
                  ],
                ),
                preview: _CalculationPreview(
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

class _CalculationPreview extends StatelessWidget {
  const _CalculationPreview({
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
                      name.isNotEmpty ? name : 'Calculation Name',
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
                          name.isNotEmpty ? name : 'Calculation Name',
                          style: AppTextStyles.paragraphMRegular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          description.isNotEmpty
                              ? description
                              : 'Calculation description',
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
