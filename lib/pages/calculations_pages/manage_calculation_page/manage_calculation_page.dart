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

  Future<void> _printPdf() async {
    await Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (PdfPageFormat format) {
        return _generatePdf(format);
      },
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
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

    if (_company != null) {
      final pdf.MultiPage companyInfo = await _getCompanyInfo(
        format: format,
        stylePrimary: stylePrimary,
        styleSecondary: styleSecondary,
      );

      document.addPage(companyInfo);
    }

    if (_project != null) {
      final pdf.MultiPage projectInfo = await _getProjectInfo(
        format: format,
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
  Future<pdf.MultiPage> _getCompanyInfo({
    required PdfPageFormat format,
    required pdf.TextStyle stylePrimary,
    required pdf.TextStyle styleSecondary,
  }) async {
    pdf.ImageProvider? companyImage;

    if (_company!.info.media != null) {
      companyImage = await networkImage(
        _company!.info.media!.first.data,
      );
    }

    final List<String> description = _company!.info.description.split('\n');

    final List<pdf.Widget> descriptionParts = [];

    for (int i = 0; i < description.length; i++) {
      final String value;

      if (i == description.length - 1) {
        value = description[i];
      } else {
        value = '${description[i]}\n';
      }

      descriptionParts.add(
        pdf.Text(value, style: styleSecondary),
      );
    }

    return pdf.MultiPage(
      pageFormat: format,
      margin: const pdf.EdgeInsets.symmetric(
        horizontal: 42.0,
        vertical: 72.0,
      ),
      build: (pdf.Context context) {
        return [
          if (companyImage != null) ...[
            pdf.Expanded(
              child: pdf.Image(
                companyImage,
                height: 256.0,
                fit: pdf.BoxFit.cover,
              ),
            ),
            pdf.SizedBox(height: 22.0),
          ],
          pdf.Column(
            crossAxisAlignment: pdf.CrossAxisAlignment.start,
            children: [
              pdf.Text(
                _company!.info.name,
                style: stylePrimary,
              ),
              pdf.SizedBox(height: 8.0),
              ...descriptionParts,
            ],
          )
        ];
      },
    );
  }

  //todo: 2
  Future<pdf.MultiPage> _getProjectInfo({
    required PdfPageFormat format,
    required pdf.TextStyle stylePrimary,
    required pdf.TextStyle styleSecondary,
  }) async {
    final List<pdf.ImageProvider> projectImages = [];

    if (_project!.info.media != null) {
      for (int i = 0; i < _project!.info.media!.length; i++) {
        final pdf.ImageProvider image = await networkImage(
          _project!.info.media![i].thumbnail,
        );

        projectImages.add(image);
      }
    }

    final List<String> description = _project!.info.description.split('\n');

    final List<pdf.Widget> descriptionParts = [];

    for (int i = 0; i < description.length; i++) {
      final String value;

      if (i == description.length - 1) {
        value = description[i];
      } else {
        value = '${description[i]}\n';
      }

      descriptionParts.add(
        pdf.Text(value, style: styleSecondary),
      );
    }

    final pdf.ImageProvider imageLocation = await imageFromAssetBundle(
      AppImages.location,
    );

    return pdf.MultiPage(
      pageFormat: format,
      margin: const pdf.EdgeInsets.symmetric(
        horizontal: 42.0,
        vertical: 72.0,
      ),
      build: (pdf.Context context) {
        return [
          if (projectImages.isNotEmpty) ...[
            pdf.Row(
              children: [
                pdf.Expanded(
                  child: pdf.Image(
                    projectImages[0],
                    height: 320.0,
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
                        height: 156.0,
                        fit: pdf.BoxFit.cover,
                      ),
                    ],
                    if (projectImages.length > 2) ...[
                      pdf.SizedBox(height: 8.0),
                      pdf.Image(
                        projectImages[2],
                        width: 180.0,
                        height: 156.0,
                        fit: pdf.BoxFit.cover,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            pdf.SizedBox(height: 22.0),
          ],
          pdf.Partitions(
            children: [
              pdf.Partition(
                child: pdf.Column(
                  crossAxisAlignment: pdf.CrossAxisAlignment.start,
                  children: [
                    pdf.Text(
                      _project!.info.name,
                      style: stylePrimary,
                    ),
                    pdf.Row(
                      children: [
                        pdf.Image(
                          imageLocation,
                          width: 14.0,
                        ),
                        pdf.SizedBox(width: 4.0),
                        pdf.Flexible(
                          child: pdf.Text(
                            _project!.info.location,
                            style: styleSecondary,
                          ),
                        ),
                      ],
                    ),
                    pdf.SizedBox(height: 10.0),
                    ...descriptionParts,
                  ],
                ),
              ),
              pdf.Partition(
                width: 42.0,
                child: pdf.SizedBox.shrink(),
              ),
              pdf.Partition(
                width: 180.0,
                child: pdf.Column(
                  crossAxisAlignment: pdf.CrossAxisAlignment.start,
                  children: [
                    pdf.SizedBox(height: 2.0),
                    pdf.Text(
                      'Feature House',
                      style: stylePrimary.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ];
      },
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
                    if (state.companies.isNotEmpty &&
                        state.projects.isNotEmpty) ...[
                      const SizedBox(height: 28.0),
                      Text(
                        'Info for clients',
                        style: AppTextStyles.paragraphLMedium,
                      ),
                      if (state.companies.isNotEmpty) ...[
                        const SizedBox(height: 16.0),
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
                      ],
                      if (state.projects.isNotEmpty) ...[
                        const SizedBox(height: 16.0),
                        AnimatedDropdown(
                          enabled: state.projects.isNotEmpty,
                          labelText: 'Project',
                          hintText: 'Select project',
                          values:
                              state.projects.map((e) => e.info.name).toList(),
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
                                labelText: 'Unit number',
                                hintText: 'Enter number',
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(32),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: BorderTextField(
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
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: BorderTextField(
                                labelText: 'Kitchen area',
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
                        onTap: _printPdf,
                      ),
                    ] else ...[
                      CustomButton(
                        text: 'Save changes',
                        onTap: _printPdf,
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
