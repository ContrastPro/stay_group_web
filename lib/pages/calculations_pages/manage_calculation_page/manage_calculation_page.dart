import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';

import '../../../models/calculations/calculation_model.dart';
import '../../../models/companies/company_model.dart';
import '../../../models/projects/project_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/calculations_repository.dart';
import '../../../repositories/companies_repository.dart';
import '../../../repositories/projects_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../resources/app_images.dart';
import '../../../resources/app_text_styles.dart';
import '../../../utils/constants.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/dropdowns/custom_dropdown.dart';
import '../../../widgets/layouts/preview_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
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
  final TextEditingController _controllerSection = TextEditingController();
  final TextEditingController _controllerFloor = TextEditingController();
  final TextEditingController _controllerNumber = TextEditingController();
  final TextEditingController _controllerType = TextEditingController();
  final TextEditingController _controllerRooms = TextEditingController();
  final TextEditingController _controllerBathrooms = TextEditingController();
  final TextEditingController _controllerTotal = TextEditingController();
  final TextEditingController _controllerLiving = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();

  bool _isLoading = false;
  bool _nameValid = false;

  String? _errorTextName;
  CompanyModel? _company;
  ProjectModel? _project;

  void _switchLoading(bool status) {
    if (_isLoading != status) {
      setState(() => _isLoading = status);
    }
  }

  void _onSelectCompany({
    String? name,
    required List<CompanyModel> companies,
  }) {
    if (name == null) return;

    final CompanyModel company = companies.firstWhere(
      (e) => e.info.name == name,
    );

    setState(() => _company = company);
  }

  void _onSelectProject({
    String? name,
    required List<ProjectModel> projects,
  }) {
    if (name == null) return;

    final ProjectModel project = projects.firstWhere(
      (e) => e.info.name == name,
    );

    setState(() => _project = project);
  }

  void _validateName(String name) {
    setState(() {
      _nameValid = name.length > 1;
    });
  }

  Future<void> _printPdf(ManageCalculationState state) async {
    await Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (PdfPageFormat format) {
        return _generatePdf(
          format: format,
          state: state,
        );
      },
    );
  }

  Future<Uint8List> _generatePdf({
    required PdfPageFormat format,
    required ManageCalculationState state,
  }) async {
    _switchLoading(true);

    final pdf.Document document = pdf.Document();

    final pdf.TtfFont fontBold = await fontFromAssetBundle(
      'assets/fonts/Inter-Medium.ttf',
    );

    final pdf.TtfFont fontRegular = await fontFromAssetBundle(
      'assets/fonts/Inter-Regular.ttf',
    );

    final pdf.TextStyle stylePrimary = pdf.TextStyle(
      font: fontBold,
      fontSize: 16.0,
      color: const PdfColor.fromInt(0xFF141C25),
    );

    final pdf.TextStyle styleSecondary = pdf.TextStyle(
      font: fontRegular,
      fontSize: 10.0,
      color: const PdfColor.fromInt(0xFF344051),
    );

    if (_project != null) {
      final pdf.Page projectInfo = await _getProjectInfo(
        format: format,
        state: state,
        stylePrimary: stylePrimary,
        styleSecondary: styleSecondary,
      );

      document.addPage(projectInfo);
    }

    final Uint8List savedDocument = await document.save();

    _switchLoading(false);

    return savedDocument;
  }

  //todo: 1
  Future<pdf.Page> _getProjectInfo({
    required PdfPageFormat format,
    required ManageCalculationState state,
    required pdf.TextStyle stylePrimary,
    required pdf.TextStyle styleSecondary,
  }) async {
    const PdfColor scaffoldSecondary = PdfColor.fromInt(0xFFFCFEFF);
    const PdfColor iconPrimary = PdfColor.fromInt(0xFF637083);
    final pdf.ImageProvider imageLocation = await imageFromAssetBundle(
      AppImages.location,
    );

    final List<pdf.ImageProvider> projectImages = [];

    if (_project!.info.media != null) {
      for (int i = 0; i < _project!.info.media!.length; i++) {
        final pdf.ImageProvider image = await networkImage(
          _project!.info.media![i].thumbnail,
        );

        projectImages.add(image);
      }
    }

    final String section = _controllerSection.text.trim();
    final String floor = _controllerFloor.text.trim();
    final String number = _controllerNumber.text.trim();
    final String type = _controllerType.text.trim();
    final String rooms = _controllerRooms.text.trim();
    final String bathrooms = _controllerBathrooms.text.trim();
    final String total = _controllerTotal.text.trim();
    final String living = _controllerLiving.text.trim();

    return pdf.Page(
      pageFormat: format,
      margin: const pdf.EdgeInsets.symmetric(
        horizontal: 42.0,
        vertical: 72.0,
      ),
      build: (pdf.Context context) {
        return pdf.Column(
          children: [
            pdf.Container(
              width: double.infinity,
              height: 72.0,
              padding: const pdf.EdgeInsets.symmetric(
                horizontal: 22.0,
              ),
              color: iconPrimary,
              child: pdf.Row(
                children: [
                  if (state.spaceData != null) ...[
                    pdf.Expanded(
                      child: pdf.Column(
                        mainAxisAlignment: pdf.MainAxisAlignment.center,
                        crossAxisAlignment: pdf.CrossAxisAlignment.start,
                        children: [
                          pdf.Text(
                            state.spaceData!.info.name,
                            style: stylePrimary.copyWith(
                              color: scaffoldSecondary,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    pdf.Expanded(
                      child: pdf.Column(
                        mainAxisAlignment: pdf.MainAxisAlignment.center,
                        crossAxisAlignment: pdf.CrossAxisAlignment.end,
                        children: [
                          pdf.Text(
                            state.userData!.info.name,
                            style: stylePrimary.copyWith(
                              color: scaffoldSecondary,
                            ),
                            maxLines: 2,
                          ),
                          pdf.Text(
                            state.userData!.credential.email,
                            style: styleSecondary.copyWith(
                              color: scaffoldSecondary,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    pdf.Column(
                      mainAxisAlignment: pdf.MainAxisAlignment.center,
                      crossAxisAlignment: pdf.CrossAxisAlignment.start,
                      children: [
                        pdf.Text(
                          state.userData!.info.name,
                          style: stylePrimary.copyWith(
                            color: scaffoldSecondary,
                          ),
                          maxLines: 2,
                        ),
                        pdf.Text(
                          state.userData!.credential.email,
                          style: styleSecondary.copyWith(
                            color: scaffoldSecondary,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            pdf.Expanded(
              child: pdf.Column(
                crossAxisAlignment: pdf.CrossAxisAlignment.start,
                children: [
                  pdf.SizedBox(height: 8.0),
                  if (projectImages.isNotEmpty) ...[
                    pdf.Row(
                      children: [
                        pdf.Expanded(
                          child: pdf.Image(
                            projectImages[0],
                            height: 256.0,
                            fit: pdf.BoxFit.cover,
                          ),
                        ),
                        pdf.SizedBox(width: 8.0),
                        pdf.Column(
                          children: [
                            if (projectImages.length > 1) ...[
                              pdf.Image(
                                projectImages[1],
                                width: 180.0,
                                height: 124.0,
                                fit: pdf.BoxFit.cover,
                              ),
                            ],
                            if (projectImages.length > 2) ...[
                              pdf.SizedBox(height: 8.0),
                              pdf.Image(
                                projectImages[2],
                                width: 180.0,
                                height: 124.0,
                                fit: pdf.BoxFit.cover,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    pdf.SizedBox(height: 16.0),
                  ],
                  pdf.Text(
                    _project!.info.name,
                    style: stylePrimary,
                    maxLines: 1,
                  ),
                  pdf.Row(
                    children: [
                      pdf.Image(
                        imageLocation,
                        width: 14.0,
                      ),
                      pdf.SizedBox(width: 4.0),
                      pdf.Text(
                        _project!.info.location,
                        style: styleSecondary,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  pdf.SizedBox(height: 10.0),
                  pdf.Text(
                    _project!.info.description,
                    style: styleSecondary,
                    maxLines: 7,
                  ),
                  pdf.SizedBox(height: 22.0),
                  pdf.Expanded(
                    child: pdf.GridView(
                      crossAxisCount: 4,
                      children: [
                        if (section.isNotEmpty) ...[
                          _getProjectFeatureItem(
                            title: 'Section',
                            data: section,
                            stylePrimary: stylePrimary,
                            styleSecondary: styleSecondary,
                          ),
                        ],
                        if (floor.isNotEmpty) ...[
                          _getProjectFeatureItem(
                            title: 'Floor',
                            data: floor,
                            stylePrimary: stylePrimary,
                            styleSecondary: styleSecondary,
                          ),
                        ],
                        if (number.isNotEmpty) ...[
                          _getProjectFeatureItem(
                            title: 'Unit number',
                            data: number,
                            stylePrimary: stylePrimary,
                            styleSecondary: styleSecondary,
                          ),
                        ],
                        if (type.isNotEmpty) ...[
                          _getProjectFeatureItem(
                            title: 'Unit type',
                            data: type,
                            stylePrimary: stylePrimary,
                            styleSecondary: styleSecondary,
                          ),
                        ],
                        if (rooms.isNotEmpty) ...[
                          _getProjectFeatureItem(
                            title: 'Rooms',
                            data: rooms,
                            stylePrimary: stylePrimary,
                            styleSecondary: styleSecondary,
                          ),
                        ],
                        if (bathrooms.isNotEmpty) ...[
                          _getProjectFeatureItem(
                            title: 'Bathrooms',
                            data: bathrooms,
                            stylePrimary: stylePrimary,
                            styleSecondary: styleSecondary,
                          ),
                        ],
                        if (total.isNotEmpty) ...[
                          _getProjectFeatureItem(
                            title: 'Total area',
                            data: total,
                            stylePrimary: stylePrimary,
                            styleSecondary: styleSecondary,
                          ),
                        ],
                        if (living.isNotEmpty) ...[
                          _getProjectFeatureItem(
                            title: 'Living area',
                            data: living,
                            stylePrimary: stylePrimary,
                            styleSecondary: styleSecondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pdf.Container(
              width: double.infinity,
              height: 72.0,
              padding: const pdf.EdgeInsets.symmetric(
                horizontal: 22.0,
              ),
              color: iconPrimary,
              child: pdf.Column(
                mainAxisAlignment: pdf.MainAxisAlignment.center,
                crossAxisAlignment: pdf.CrossAxisAlignment.start,
                children: [
                  if (_company != null) ...[
                    pdf.Text(
                      'About company',
                      style: stylePrimary.copyWith(
                        fontSize: 10.0,
                        color: scaffoldSecondary,
                      ),
                    ),
                    pdf.SizedBox(height: 1.5),
                    pdf.Text(
                      '${_company!.info.name}. ${_company!.info.description}',
                      style: styleSecondary.copyWith(
                        fontSize: 8.0,
                        color: scaffoldSecondary,
                      ),
                      maxLines: 3,
                    ),
                  ] else ...[
                    pdf.Text(
                      'www.staygroup.space',
                      style: stylePrimary.copyWith(
                        fontSize: 10.0,
                        color: scaffoldSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  pdf.Padding _getProjectFeatureItem({
    required String title,
    required String data,
    required pdf.TextStyle stylePrimary,
    required pdf.TextStyle styleSecondary,
  }) {
    return pdf.Padding(
      padding: const pdf.EdgeInsets.only(
        right: 16.0,
      ),
      child: pdf.Column(
        crossAxisAlignment: pdf.CrossAxisAlignment.start,
        children: [
          pdf.Text(
            title,
            style: stylePrimary.copyWith(
              fontSize: 10.0,
            ),
          ),
          pdf.Text(
            data,
            style: styleSecondary.copyWith(
              fontSize: 8.0,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManageCalculationBloc>(
      create: (_) => ManageCalculationBloc(
        authRepository: context.read<AuthRepository>(),
        calculationsRepository: context.read<CalculationsRepository>(),
        companiesRepository: context.read<CompaniesRepository>(),
        projectsRepository: context.read<ProjectsRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const Init(),
        ),
      child: BlocConsumer<ManageCalculationBloc, ManageCalculationState>(
        listener: (_, state) {
          if (state.status == BlocStatus.loading) {
            //
          }

          if (state.status == BlocStatus.loaded) {
            //
          }

          if (state.status == BlocStatus.success) {
            //
          }
        },
        builder: (context, state) {
          if (state.userData != null) {
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
                      widget.calculation == null
                          ? 'Add new calculation'
                          : 'Edit calculation',
                      style: AppTextStyles.head5SemiBold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.calculation == null
                          ? 'Create calculation for your clients'
                          : 'Edit calculation info',
                      style: AppTextStyles.paragraphSRegular.copyWith(
                        color: AppColors.iconPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (state.projects.isNotEmpty) ...[
                      const SizedBox(height: 28.0),
                      Text(
                        'Info for clients',
                        style: AppTextStyles.paragraphLMedium,
                      ),
                      const SizedBox(height: 16.0),
                      if (state.companies.isNotEmpty) ...[
                        AnimatedDropdown(
                          enabled: state.companies.isNotEmpty,
                          labelText: 'Company',
                          hintText: 'Select company',
                          values:
                              state.companies.map((e) => e.info.name).toList(),
                          onChanged: (String? name) => _onSelectCompany(
                            name: name,
                            companies: state.companies,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                      AnimatedDropdown(
                        enabled: state.projects.isNotEmpty,
                        labelText: 'Project',
                        hintText: 'Select project',
                        values: state.projects.map((e) => e.info.name).toList(),
                        onChanged: (String? name) => _onSelectProject(
                          name: name,
                          projects: state.projects,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: BorderTextField(
                              controller: _controllerSection,
                              labelText: 'Section',
                              hintText: 'Block or section',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(32),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: BorderTextField(
                              controller: _controllerFloor,
                              labelText: 'Floor',
                              hintText: 'Floor apartment',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: BorderTextField(
                              controller: _controllerNumber,
                              labelText: 'Unit number',
                              hintText: 'Enter number',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(32),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: BorderTextField(
                              controller: _controllerType,
                              labelText: 'Unit type',
                              hintText: 'Enter type',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(32),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: BorderTextField(
                              controller: _controllerRooms,
                              labelText: 'Rooms',
                              hintText: 'Number of rooms',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: BorderTextField(
                              controller: _controllerBathrooms,
                              labelText: 'Bathrooms',
                              hintText: 'Number of bathrooms',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: BorderTextField(
                              controller: _controllerTotal,
                              labelText: 'Total area',
                              hintText: 'Enter area',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(8),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: BorderTextField(
                              controller: _controllerLiving,
                              labelText: 'Living area',
                              hintText: 'Enter area',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(8),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 28.0),
                    Text(
                      'Calculation data',
                      style: AppTextStyles.paragraphLMedium,
                    ),
                    const SizedBox(height: 16.0),
                    BorderTextField(
                      controller: _controllerName,
                      labelText: 'Name',
                      hintText: 'Calculation name',
                      errorText: _errorTextName,
                      maxLines: 2,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(128),
                      ],
                      onChanged: _validateName,
                    ),
                    const SizedBox(height: 40.0),
                    if (widget.calculation == null) ...[
                      CustomButton(
                        text: 'Create calculation',
                        onTap: () => _printPdf(state),
                      ),
                    ] else ...[
                      CustomButton(
                        text: 'Save changes',
                        onTap: () => _printPdf(state),
                      ),
                    ],
                    const SizedBox(height: 12.0),
                    CustomTextButton(
                      prefixIcon: AppIcons.arrowBack,
                      text: 'Back to Calculations page',
                      onTap: widget.navigateToCalculationsPage,
                    ),
                  ],
                ),
                preview: _CalculationPreview(
                  company: _company,
                  project: _project,
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

class _CalculationPreview extends StatelessWidget {
  const _CalculationPreview({
    this.company,
    this.project,
  });

  final CompanyModel? company;
  final ProjectModel? project;

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
