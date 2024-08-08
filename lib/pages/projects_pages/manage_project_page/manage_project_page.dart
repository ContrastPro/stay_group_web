import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/projects/project_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/projects_repository.dart';
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
import 'blocs/manage_project_bloc/manage_project_bloc.dart';

class ManageProjectPage extends StatefulWidget {
  const ManageProjectPage({
    super.key,
    this.project,
    required this.navigateToProjectsPage,
  });

  static const routePath = '/projects_pages/manage_project';

  final ProjectModel? project;
  final void Function() navigateToProjectsPage;

  @override
  State<ManageProjectPage> createState() => _ManageProjectPageState();
}

class _ManageProjectPageState extends State<ManageProjectPage> {
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
    if (widget.project != null) {
      _controllerName.text = widget.project!.info.name;
      _validateName(widget.project!.info.name);
      _controllerDescription.text = widget.project!.info.description;
      _validateDescription(widget.project!.info.description);
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

  void _createProject(BuildContext context) {
    _switchErrorName();
    _switchErrorDescription();

    final String name = _controllerName.text.trim();
    final String description = _controllerDescription.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Project name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    if (description.isEmpty || !_descriptionValid) {
      const String errorFormat = 'Project description is too short';

      _switchErrorDescription(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    context.read<ManageProjectBloc>().add(
          CreateProject(
            name: name,
            description: description,
          ),
        );
  }

  void _updateProject(BuildContext context) {
    _switchErrorName();
    _switchErrorDescription();

    final String name = _controllerName.text.trim();
    final String description = _controllerDescription.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Project name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    if (description.isEmpty || !_descriptionValid) {
      const String errorFormat = 'Project description is too short';

      _switchErrorDescription(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    context.read<ManageProjectBloc>().add(
          UpdateProject(
            id: widget.project!.id,
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
    return BlocProvider<ManageProjectBloc>(
      create: (_) => ManageProjectBloc(
        authRepository: context.read<AuthRepository>(),
        projectsRepository: context.read<ProjectsRepository>(),
        usersRepository: context.read<UsersRepository>(),
      ),
      child: Scaffold(
        body: BlocConsumer<ManageProjectBloc, ManageProjectState>(
          listener: (_, state) {
            if (state.status == BlocStatus.loading) {
              _switchLoading(true);
            }

            if (state.status == BlocStatus.loaded) {
              _switchLoading(false);
            }

            if (state.status == BlocStatus.success) {
              InAppNotificationService.show(
                title: widget.project == null
                    ? 'Project successfully created'
                    : 'Project successfully updated',
                type: InAppNotificationType.success,
              );

              widget.navigateToProjectsPage();
            }
          },
          builder: (context, state) {
            return ActionLoader(
              isLoading: _isLoading,
              child: ManagePreviewLayout(
                content: Column(
                  children: [
                    Text(
                      widget.project == null
                          ? 'Add new project'
                          : 'Edit project',
                      style: AppTextStyles.head5SemiBold,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.project == null
                          ? 'Create your project'
                          : 'Edit your project info',
                      style: AppTextStyles.paragraphSRegular.copyWith(
                        color: AppColors.iconPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28.0),
                    BorderTextField(
                      controller: _controllerName,
                      labelText: 'Name',
                      hintText: 'Project name',
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
                      hintText: 'Project description',
                      prefixIcon: AppIcons.mail,
                      errorText: _errorTextDescription,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4096),
                      ],
                      onChanged: _validateDescription,
                    ),
                    const SizedBox(height: 40.0),
                    if (widget.project == null) ...[
                      CustomButton(
                        text: 'Create project',
                        onTap: () => _createProject(context),
                      ),
                    ] else ...[
                      CustomButton(
                        text: 'Save changes',
                        onTap: () => _updateProject(context),
                      ),
                    ],
                    const SizedBox(height: 12.0),
                    CustomTextButton(
                      prefixIcon: AppIcons.arrowBack,
                      text: 'Back to projects page',
                      onTap: widget.navigateToProjectsPage,
                    ),
                  ],
                ),
                preview: _ProjectPreview(
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

class _ProjectPreview extends StatelessWidget {
  const _ProjectPreview({
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
                      name.isNotEmpty ? name : 'Project Name',
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
                          name.isNotEmpty ? name : 'Project Name',
                          style: AppTextStyles.paragraphMRegular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          description.isNotEmpty
                              ? description
                              : 'Project description',
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
