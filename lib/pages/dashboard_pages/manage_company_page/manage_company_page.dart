import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/layouts/preview_layout.dart';
import '../../../widgets/loaders/cached_network_image_loader.dart';
import '../../../widgets/text_fields/border_text_field.dart';
import '../../../widgets/uncategorized/media_organizer.dart';
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
      const String errorFormat = 'Company description is too short';

      _switchErrorDescription(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
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
      const String errorFormat = 'Company description is too short';

      _switchErrorDescription(error: errorFormat);
      return _showErrorMessage(errorMessage: errorFormat);
    }

    final List<MediaModel> savedMedia = _getSavedMedia();
    final List<MediaResponseModel> addedMedia = _getAddedMedia();
    final List<MediaModel> removedMedia = _getRemovedMedia();

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

  List<MediaModel> _getSavedMedia() {
    final List<MediaModel> savedMedia = [];

    final CompanyInfoModel info = widget.company!.info;

    if (info.media != null) {
      for (int i = 0; i < info.media!.length; i++) {
        final int index = _media.indexWhere((e) => e.id == info.media![i].id);

        if (index != -1) {
          savedMedia.add(info.media![i]);
        }
      }
    }

    return savedMedia;
  }

  List<MediaResponseModel> _getAddedMedia() {
    final List<MediaResponseModel> addedMedia = [];

    final CompanyInfoModel info = widget.company!.info;

    if (info.media != null) {
      for (int i = 0; i < _media.length; i++) {
        final int index = info.media!.indexWhere((e) => e.id == _media[i].id);

        if (index == -1) {
          addedMedia.add(_media[i]);
        }
      }
    } else {
      addedMedia.addAll(_media);
    }

    return addedMedia;
  }

  List<MediaModel> _getRemovedMedia() {
    final List<MediaModel> removedMedia = [];

    final CompanyInfoModel info = widget.company!.info;

    if (info.media != null) {
      for (int i = 0; i < info.media!.length; i++) {
        final int index = _media.indexWhere((e) => e.id == info.media![i].id);

        if (index == -1) {
          removedMedia.add(info.media![i]);
        }
      }
    }

    return removedMedia;
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
              child: PreviewLayout(
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
                          ? 'Create building company card'
                          : 'Edit building company card',
                      style: AppTextStyles.paragraphSRegular.copyWith(
                        color: AppColors.iconPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28.0),
                    MediaOrganizer(
                      labelText: 'Upload logo',
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
                      prefixIcon: AppIcons.user,
                      errorText: _errorTextName,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(64),
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
    required this.media,
    required this.name,
    required this.description,
  });

  final List<MediaResponseModel> media;
  final String name;
  final String description;

  static const BorderRadiusGeometry _borderRadius = BorderRadius.only(
    topLeft: Radius.circular(8.0),
    topRight: Radius.circular(8.0),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 180.0,
            decoration: const BoxDecoration(
              borderRadius: _borderRadius,
              gradient: AppColors.userGradient,
            ),
            child: media.isNotEmpty
                ? FadeInAnimation(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7.0),
                        topRight: Radius.circular(7.0),
                      ),
                      child: media.first.dataUrl != null
                          ? CachedNetworkImageLoader(
                              imageUrl: media.first.dataUrl,
                            )
                          : Image.memory(
                              media.first.data!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  )
                : null,
          ),
          Container(
            height: 4.0,
            color: AppColors.border,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ).copyWith(
              top: 16.0,
              bottom: 14.0,
            ),
            decoration: const BoxDecoration(
              color: AppColors.scaffoldSecondary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : 'Company Name',
                  style: AppTextStyles.paragraphMSemiBold,
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
    );
  }
}
