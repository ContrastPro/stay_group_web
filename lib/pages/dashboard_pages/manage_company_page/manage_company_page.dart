import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/companies/company_info_model.dart';
import '../../../models/companies/company_model.dart';
import '../../../models/medias/media_model.dart';
import '../../../models/medias/media_response_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/companies_repository.dart';
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
import '../../../widgets/layouts/preview_layout.dart';
import '../../../widgets/loaders/cached_network_image_loader.dart';
import '../../../widgets/text_fields/border_text_field.dart';
import '../../../widgets/uncategorized/media_organizer.dart';
import '../../uncategorized_pages/media_viewer_page/media_viewer_page.dart';
import 'blocs/manage_company_bloc/manage_company_bloc.dart';

class ManageCompanyPage extends StatefulWidget {
  const ManageCompanyPage({
    super.key,
    this.company,
    required this.navigateToMediaViewerPage,
    required this.navigateToDashboardPage,
  });

  static const routePath = '/dashboard_pages/manage_company';

  final CompanyModel? company;
  final void Function(MediaViewerPageArguments) navigateToMediaViewerPage;
  final void Function() navigateToDashboardPage;

  @override
  State<ManageCompanyPage> createState() => _ManageCompanyPageState();
}

class _ManageCompanyPageState extends State<ManageCompanyPage> {
  final List<MediaResponseModel> _media = [];
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
      final CompanyInfoModel info = widget.company!.info;

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
      const String errorDescription = 'Company description is too short';

      _switchErrorDescription(error: errorDescription);
      return _showErrorMessage(errorMessage: errorDescription);
    }

    context.read<ManageCompanyBloc>().add(
          CreateCompany(
            media: _media,
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
      const String errorDescription = 'Company description is too short';

      _switchErrorDescription(error: errorDescription);
      return _showErrorMessage(errorMessage: errorDescription);
    }

    final List<MediaModel>? media = widget.company!.info.media;

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

    context.read<ManageCompanyBloc>().add(
          UpdateCompany(
            id: widget.company!.id,
            savedMedia: savedMedia,
            addedMedia: addedMedia,
            removedMedia: removedMedia,
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
        storageRepository: context.read<StorageRepository>(),
        usersRepository: context.read<UsersRepository>(),
      ),
      child: BlocConsumer<ManageCompanyBloc, ManageCompanyState>(
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
            child: PreviewLayout(
              content: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 42.0,
                ),
                children: [
                  Text(
                    widget.company == null ? 'Add new company' : 'Edit company',
                    style: AppTextStyles.head5SemiBold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.company == null
                        ? 'Create building company card'
                        : 'Edit building company card',
                    style: AppTextStyles.paragraphSRegular.copyWith(
                      color: AppColors.iconPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28.0),
                  MediaOrganizer(
                    labelText: 'Upload banner',
                    maxLength: 1,
                    media: _media,
                    onPickMedia: _onPickMedia,
                    onDeleteMedia: _onDeleteMedia,
                  ),
                  const SizedBox(height: 8.0),
                  BorderTextField(
                    controller: _controllerName,
                    labelText: 'Name',
                    hintText: 'Company name',
                    errorText: _errorTextName,
                    maxLines: 2,
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
                    errorText: _errorTextDescription,
                    maxLines: 6,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(320),
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
                media: _media,
                name: _controllerName.text,
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

class _CompanyPreview extends StatelessWidget {
  const _CompanyPreview({
    required this.media,
    required this.name,
    required this.description,
    required this.navigateToMediaViewerPage,
  });

  final List<MediaResponseModel> media;
  final String name;
  final String description;
  final void Function(MediaViewerPageArguments) navigateToMediaViewerPage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 640.0,
          height: 384.0,
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ).copyWith(
            left: 16.0,
            right: 22.0,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 42.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.scaffoldSecondary,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 256.0,
                height: double.infinity,
                child: media.isNotEmpty
                    ? FadeInAnimation(
                        child: GestureDetector(
                          onTap: () => navigateToMediaViewerPage(
                            MediaViewerPageArguments(
                              index: 0,
                              media: media,
                            ),
                          ),
                          behavior: HitTestBehavior.opaque,
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
                      )
                    : Container(
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
              ),
              const SizedBox(width: 28.0),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                  ),
                  children: [
                    const SizedBox(height: 16.0),
                    Text(
                      name.isNotEmpty ? name : 'Company Name',
                      style: AppTextStyles.subtitleSemiBold,
                    ),
                    Text(
                      description.isNotEmpty
                          ? description
                          : 'Ownership, Location, etc..',
                      style: AppTextStyles.paragraphSRegular,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
