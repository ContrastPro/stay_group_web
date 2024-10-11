import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/companies/company_info_model.dart';
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
import '../../../utils/translate_locale.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/custom_icon_button.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/layouts/preview_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/text_fields/custom_text_field.dart';
import '../../uncategorized_pages/media_viewer_page/media_viewer_page.dart';
import 'blocs/manage_company_bloc/manage_company_bloc.dart';

const TranslateLocale _locale = TranslateLocale('dashboard.manage_company');

class ManageCompanyPage extends StatefulWidget {
  const ManageCompanyPage({
    super.key,
    this.id,
    required this.navigateToMediaViewerPage,
    required this.navigateToDashboardPage,
  });

  static const routePath = '/dashboard_pages/manage_company';

  final String? id;
  final void Function(MediaViewerPageArguments) navigateToMediaViewerPage;
  final void Function() navigateToDashboardPage;

  @override
  State<ManageCompanyPage> createState() => _ManageCompanyPageState();
}

class _ManageCompanyPageState extends State<ManageCompanyPage> {
  final List<MediaResponseModel> _media = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  bool _dataLoaded = false;
  bool _isLoading = false;
  bool _nameValid = false;
  bool _descriptionValid = false;

  String? _errorTextName;
  String? _errorTextDescription;

  void _setInitialData(ManageCompanyState state) {
    if (_dataLoaded) return;

    if (state.company == null) {
      return _switchDataLoaded(true);
    }

    final CompanyInfoModel info = state.company!.info;

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

  void _validateDescription(String description) {
    setState(() => _descriptionValid = description.length > 1);
  }

  void _createCompany({
    required BuildContext context,
    required ManageCompanyState state,
  }) {
    _switchErrorName();
    _switchErrorDescription();

    if (state.companies.length > 2) {
      final String errorLimit = _locale.tr('limit_reached');
      return _showErrorMessage(errorMessage: errorLimit);
    }

    final String name = _controllerName.text.trim();
    final String description = _controllerDescription.text.trim();

    if (name.isEmpty || !_nameValid) {
      final String errorName = _locale.tr('name_short');

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    if (description.isEmpty || !_descriptionValid) {
      final String errorDescription = _locale.tr('description_short');

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

  void _updateCompany({
    required BuildContext context,
    required ManageCompanyState state,
  }) {
    _switchErrorName();
    _switchErrorDescription();

    final String name = _controllerName.text.trim();
    final String description = _controllerDescription.text.trim();

    if (name.isEmpty || !_nameValid) {
      final String errorName = _locale.tr('name_short');

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    if (description.isEmpty || !_descriptionValid) {
      final String errorDescription = _locale.tr('description_short');

      _switchErrorDescription(error: errorDescription);
      return _showErrorMessage(errorMessage: errorDescription);
    }

    final List<MediaModel>? media = state.company!.info.media;

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
            savedMedia: savedMedia,
            addedMedia: addedMedia,
            removedMedia: removedMedia,
            name: name,
            description: description,
          ),
        );
  }

  void _switchErrorName({String? error}) {
    setState(() => _errorTextName = error);
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
    return BlocProvider<ManageCompanyBloc>(
      create: (_) => ManageCompanyBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
        companiesRepository: context.read<CompaniesRepository>(),
        storageRepository: context.read<StorageRepository>(),
      )..add(
          Init(
            id: widget.id,
          ),
        ),
      child: BlocConsumer<ManageCompanyBloc, ManageCompanyState>(
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
              title: _locale.tr(
                state.company == null ? 'company_created' : 'company_updated',
              ),
              type: InAppNotificationType.success,
            );

            if (state.company == null) {
              widget.navigateToDashboardPage();
            }
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
                        onTap: widget.navigateToDashboardPage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    _locale.tr(
                      state.company == null ? 'add_company' : 'edit_company',
                    ),
                    style: AppTextStyles.head5SemiBold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _locale.tr(
                      state.company == null
                          ? 'create_company_card'
                          : 'edit_company_card',
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
                    hintText: _locale.tr('company_name'),
                    errorText: _errorTextName,
                    maxLines: 2,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(64),
                    ],
                    onChanged: _validateName,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    controller: _controllerDescription,
                    labelText: _locale.tr('description'),
                    hintText: _locale.tr('company_description'),
                    errorText: _errorTextDescription,
                    maxLines: 14,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(640),
                    ],
                    onChanged: _validateDescription,
                  ),
                  const SizedBox(height: 40.0),
                  if (state.company == null) ...[
                    CustomButton(
                      text: _locale.tr('create_company'),
                      onTap: () => _createCompany(
                        context: context,
                        state: state,
                      ),
                    ),
                  ] else ...[
                    CustomButton(
                      text: _locale.tr('save_changes'),
                      onTap: () => _updateCompany(
                        context: context,
                        state: state,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12.0),
                  CustomTextButton(
                    prefixIcon: AppIcons.arrowBack,
                    text: _locale.tr('back_dashboard'),
                    onTap: widget.navigateToDashboardPage,
                  ),
                ],
                preview: _CompanyPreview(
                  media: _media,
                  name: _controllerName.text,
                  description: _controllerDescription.text,
                  navigateToMediaViewerPage: widget.navigateToMediaViewerPage,
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 32.0,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 32.0,
      ),
      constraints: const BoxConstraints(
        minWidth: 512.0,
        minHeight: 256.0,
        maxWidth: 512.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.scaffoldSecondary,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.isNotEmpty ? name : _locale.tr('company_name'),
            style: AppTextStyles.subtitleSemiBold,
          ),
          Text(
            description.isNotEmpty
                ? description
                : _locale.tr('ownership_location'),
            style: AppTextStyles.paragraphSRegular,
          ),
        ],
      ),
    );
  }
}
