import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/medias/media_model.dart';
import '../../../models/medias/media_response_model.dart';
import '../../../models/projects/project_info_model.dart';
import '../../../models/projects/project_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/projects_repository.dart';
import '../../../repositories/storage_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../resources/app_text_styles.dart';
import '../../../services/in_app_notification_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/data_pickers/custom_media_picker.dart';
import '../../../widgets/layouts/preview_layout.dart';
import '../../../widgets/loaders/cached_network_image_loader.dart';
import '../../../widgets/text_fields/border_text_field.dart';
import '../../uncategorized_pages/media_viewer_page/media_viewer_page.dart';
import 'blocs/manage_project_bloc/manage_project_bloc.dart';

class ManageProjectPageArguments {
  const ManageProjectPageArguments({
    required this.count,
    this.project,
  });

  final int count;
  final ProjectModel? project;
}

class ManageProjectPage extends StatefulWidget {
  const ManageProjectPage({
    super.key,
    required this.count,
    this.project,
    required this.navigateToMediaViewerPage,
    required this.navigateToProjectsPage,
  });

  static const routePath = '/projects_pages/manage_project';

  final int count;
  final ProjectModel? project;
  final void Function(MediaViewerPageArguments) navigateToMediaViewerPage;
  final void Function() navigateToProjectsPage;

  @override
  State<ManageProjectPage> createState() => _ManageProjectPageState();
}

class _ManageProjectPageState extends State<ManageProjectPage> {
  final List<MediaResponseModel> _media = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLocation = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  bool _isLoading = false;
  bool _nameValid = false;
  bool _locationValid = false;
  bool _descriptionValid = false;

  String? _errorTextName;
  String? _errorTextLocation;
  String? _errorTextDescription;

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    if (widget.project != null) {
      final ProjectInfoModel info = widget.project!.info;

      if (info.media != null) {
        for (int i = 0; i < info.media!.length; i++) {
          final MediaModel media = info.media![i];

          _media.add(
            MediaResponseModel(
              id: media.id,
              dataUrl: media.data,
              thumbnailUrl: media.thumbnail,
              format: media.format,
              name: media.name,
            ),
          );
        }
      }

      _controllerName.text = info.name;
      _validateName(info.name);
      _controllerLocation.text = info.location;
      _validateLocation(info.location);
      _controllerDescription.text = info.description;
      _validateDescription(info.description);
    }
  }

  void _switchLoading(bool status) {
    if (_isLoading != status) {
      setState(() => _isLoading = status);
    }
  }

  void _onPickMedia(MediaResponseModel media) {
    setState(() => _media.add(media));
  }

  void _onDeleteMedia(MediaResponseModel media) {
    setState(() {
      _media.removeWhere((e) => e.id == media.id);
    });
  }

  void _validateName(String name) {
    setState(() => _nameValid = name.length > 1);
  }

  void _validateLocation(String location) {
    setState(() => _locationValid = location.length > 1);
  }

  void _validateDescription(String description) {
    setState(() => _descriptionValid = description.length > 1);
  }

  void _createProject(BuildContext context) {
    _switchErrorName();
    _switchErrorLocation();
    _switchErrorDescription();

    if (widget.count > 9) {
      const String errorLimit =
          'The limit for creating projects for the workspace has been reached';
      return _showErrorMessage(errorMessage: errorLimit);
    }

    final String name = _controllerName.text.trim();
    final String location = _controllerLocation.text.trim();
    final String description = _controllerDescription.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Project name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    if (location.isEmpty || !_locationValid) {
      const String errorLocation = 'Location is too short';

      _switchErrorLocation(error: errorLocation);
      return _showErrorMessage(errorMessage: errorLocation);
    }

    if (description.isEmpty || !_descriptionValid) {
      const String errorDescription = 'Project description is too short';

      _switchErrorDescription(error: errorDescription);
      return _showErrorMessage(errorMessage: errorDescription);
    }

    context.read<ManageProjectBloc>().add(
          CreateProject(
            media: _media,
            name: name,
            location: location,
            description: description,
          ),
        );
  }

  void _updateProject(BuildContext context) {
    _switchErrorName();
    _switchErrorLocation();
    _switchErrorDescription();

    final String name = _controllerName.text.trim();
    final String location = _controllerLocation.text.trim();
    final String description = _controllerDescription.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Project name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    if (location.isEmpty || !_locationValid) {
      const String errorLocation = 'Location is too short';

      _switchErrorLocation(error: errorLocation);
      return _showErrorMessage(errorMessage: errorLocation);
    }

    if (description.isEmpty || !_descriptionValid) {
      const String errorDescription = 'Project description is too short';

      _switchErrorDescription(error: errorDescription);
      return _showErrorMessage(errorMessage: errorDescription);
    }

    final List<MediaModel>? media = widget.project!.info.media;

    final List<MediaModel> savedMedia = getSavedMedia(
      media: media,
      localMedia: _media,
    );

    final List<MediaResponseModel> addedMedia = getAddedMedia(
      media: media,
      localMedia: _media,
    );

    final List<MediaModel> removedMedia = getRemovedMedia(
      media: media,
      localMedia: _media,
    );

    context.read<ManageProjectBloc>().add(
          UpdateProject(
            id: widget.project!.id,
            savedMedia: savedMedia,
            addedMedia: addedMedia,
            removedMedia: removedMedia,
            name: name,
            location: location,
            description: description,
            createdAt: widget.project!.metadata.createdAt,
          ),
        );
  }

  void _switchErrorName({String? error}) {
    setState(() => _errorTextName = error);
  }

  void _switchErrorLocation({String? error}) {
    setState(() => _errorTextLocation = error);
  }

  void _switchErrorDescription({String? error}) {
    setState(() => _errorTextDescription = error);
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
        storageRepository: context.read<StorageRepository>(),
        usersRepository: context.read<UsersRepository>(),
      ),
      child: BlocConsumer<ManageProjectBloc, ManageProjectState>(
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
            child: PreviewLayout(
              content: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 42.0,
                ),
                children: [
                  Text(
                    widget.project == null ? 'Add new project' : 'Edit project',
                    style: AppTextStyles.head5SemiBold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.project == null
                        ? 'Create project card'
                        : 'Edit project card',
                    style: AppTextStyles.paragraphSRegular.copyWith(
                      color: AppColors.iconPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28.0),
                  CustomMediaPicker(
                    labelText: 'Upload images',
                    media: _media,
                    onPickMedia: _onPickMedia,
                    onDeleteMedia: _onDeleteMedia,
                  ),
                  const SizedBox(height: 8.0),
                  BorderTextField(
                    controller: _controllerName,
                    labelText: 'Name',
                    hintText: 'Project name',
                    errorText: _errorTextName,
                    maxLines: 2,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(64),
                    ],
                    onChanged: _validateName,
                  ),
                  const SizedBox(height: 16.0),
                  BorderTextField(
                    controller: _controllerLocation,
                    labelText: 'Location',
                    hintText: 'Project location',
                    errorText: _errorTextLocation,
                    maxLines: 2,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(64),
                    ],
                    onChanged: _validateLocation,
                  ),
                  const SizedBox(height: 16.0),
                  BorderTextField(
                    controller: _controllerDescription,
                    labelText: 'Description',
                    hintText: 'Project description',
                    errorText: _errorTextDescription,
                    maxLines: 14,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(640),
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
                    text: 'Back to Projects page',
                    onTap: widget.navigateToProjectsPage,
                  ),
                ],
              ),
              preview: _ProjectPreview(
                media: _media,
                name: _controllerName.text,
                location: _controllerLocation.text,
                description: _controllerDescription.text,
                navigateToMediaViewerPage: widget.navigateToMediaViewerPage,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProjectPreview extends StatelessWidget {
  const _ProjectPreview({
    required this.media,
    required this.name,
    required this.location,
    required this.description,
    required this.navigateToMediaViewerPage,
  });

  final List<MediaResponseModel> media;
  final String name;
  final String location;
  final String description;
  final void Function(MediaViewerPageArguments) navigateToMediaViewerPage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 42.0,
      ),
      child: Column(
        children: [
          Container(
            width: 640.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ).copyWith(
              top: 16.0,
              bottom: 32.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.scaffoldSecondary,
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 384.0,
                  child: Row(
                    children: [
                      _BannerItem(
                        media: media,
                        navigateToMediaViewerPage: navigateToMediaViewerPage,
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        children: [
                          _ImageItem(
                            index: 1,
                            media: media,
                            navigateToMediaViewerPage:
                                navigateToMediaViewerPage,
                          ),
                          const SizedBox(height: 8.0),
                          _ImageItem(
                            index: 2,
                            media: media,
                            navigateToMediaViewerPage:
                                navigateToMediaViewerPage,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : 'Project Name',
                      style: AppTextStyles.subtitleSemiBold,
                      maxLines: 2,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.location,
                          width: 16.0,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Flexible(
                          child: Text(
                            location.isNotEmpty ? location : 'location',
                            style: AppTextStyles.paragraphSRegular,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18.0),
                    Text(
                      'Project details',
                      style: AppTextStyles.paragraphMSemiBold,
                    ),
                    Text(
                      description.isNotEmpty
                          ? description
                          : 'Ownership, Date of construction, etc..',
                      style: AppTextStyles.paragraphSRegular,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerItem extends StatelessWidget {
  const _BannerItem({
    required this.media,
    required this.navigateToMediaViewerPage,
  });

  final List<MediaResponseModel> media;
  final void Function(MediaViewerPageArguments) navigateToMediaViewerPage;

  @override
  Widget build(BuildContext context) {
    if (media.isNotEmpty) {
      return Expanded(
        child: GestureDetector(
          onTap: () => navigateToMediaViewerPage(
            MediaViewerPageArguments(
              index: 0,
              media: media,
            ),
          ),
          behavior: HitTestBehavior.opaque,
          child: FadeInAnimation(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26.0),
              child: media.first.dataUrl != null
                  ? CachedNetworkImageLoader(
                      imageUrl: media.first.dataUrl!,
                    )
                  : Image.memory(
                      media.first.data!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(26.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.placeholder,
              width: 64.0,
              colorFilter: ColorFilter.mode(
                AppColors.iconPrimary.withOpacity(0.4),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Max file size: ${formatMediaSize(kFileWeightMax)}',
              style: AppTextStyles.captionBold.copyWith(
                color: AppColors.iconPrimary.withOpacity(0.6),
              ),
            ),
            Text(
              '.jpg .jpeg .png',
              style: AppTextStyles.captionRegular.copyWith(
                color: AppColors.iconPrimary.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageItem extends StatelessWidget {
  const _ImageItem({
    required this.index,
    required this.media,
    required this.navigateToMediaViewerPage,
  });

  final int index;
  final List<MediaResponseModel> media;
  final void Function(MediaViewerPageArguments) navigateToMediaViewerPage;

  @override
  Widget build(BuildContext context) {
    if (media.length > index) {
      return Expanded(
        child: GestureDetector(
          onTap: () => navigateToMediaViewerPage(
            MediaViewerPageArguments(
              index: index,
              media: media,
            ),
          ),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 220.0,
            height: 128.0,
            child: FadeInAnimation(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26.0),
                child: media[index].dataUrl != null
                    ? CachedNetworkImageLoader(
                        imageUrl: media[index].dataUrl!,
                      )
                    : Image.memory(
                        media[index].data!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        width: 220.0,
        height: 128.0,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(26.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.placeholder,
              width: 42.0,
              colorFilter: ColorFilter.mode(
                AppColors.iconPrimary.withOpacity(0.4),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
