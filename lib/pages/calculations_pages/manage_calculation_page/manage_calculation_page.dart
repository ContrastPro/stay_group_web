import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';

import '../../../models/calculations/calculation_info_model.dart';
import '../../../models/calculations/calculation_model.dart';
import '../../../models/calculations/calculation_period_model.dart';
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
import '../../../services/in_app_notification_service.dart';
import '../../../utils/constants.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/data_pickers/custom_date_picker.dart';
import '../../../widgets/dropdowns/custom_dropdown.dart';
import '../../../widgets/layouts/preview_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/text_fields/border_text_field.dart';
import 'blocs/manage_calculation_bloc/manage_calculation_bloc.dart';

class ManageCalculationPageArguments {
  const ManageCalculationPageArguments({
    required this.count,
    this.calculation,
  });

  final int count;
  final CalculationModel? calculation;
}

class ManageCalculationPage extends StatefulWidget {
  const ManageCalculationPage({
    super.key,
    required this.count,
    this.calculation,
    required this.navigateToCalculationsPage,
  });

  static const routePath = '/calculations_pages/manage_calculation';

  final int count;
  final CalculationModel? calculation;
  final void Function() navigateToCalculationsPage;

  @override
  State<ManageCalculationPage> createState() => _ManageCalculationPageState();
}

class _ManageCalculationPageState extends State<ManageCalculationPage> {
  static const List<CalculationPeriodModel> _periods = [
    CalculationPeriodModel(
      month: 1,
      name: 'Every month',
    ),
    CalculationPeriodModel(
      month: 3,
      name: 'Every quarter',
    ),
    CalculationPeriodModel(
      month: 6,
      name: 'Every six months',
    ),
  ];

  final TextEditingController _controllerSection = TextEditingController();
  final TextEditingController _controllerFloor = TextEditingController();
  final TextEditingController _controllerNumber = TextEditingController();
  final TextEditingController _controllerType = TextEditingController();
  final TextEditingController _controllerRooms = TextEditingController();
  final TextEditingController _controllerBathrooms = TextEditingController();
  final TextEditingController _controllerTotal = TextEditingController();
  final TextEditingController _controllerLiving = TextEditingController();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerDepositVal = TextEditingController();
  final TextEditingController _controllerDepositPct = TextEditingController();

  bool _dataLoaded = false;
  bool _isLoading = false;
  bool _nameValid = false;
  bool _priceValid = false;

  CompanyModel? _company;
  ProjectModel? _project;
  String? _errorTextName;
  CalculationPeriodModel? _period;
  DateTime? _startInstallments;
  DateTime? _endInstallments;

  void _setInitialData(ManageCalculationState state) {
    if (_dataLoaded) return;

    if (widget.calculation == null) {
      return _switchDataLoaded(true);
    }

    final CalculationInfoModel info = widget.calculation!.info;

    if (info.companyId != null) {
      final CompanyModel? company = state.companies.firstWhereOrNull(
        (e) => e.id == info.companyId,
      );

      setState(() => _company = company);
    }

    if (info.projectId != null) {
      final ProjectModel? project = state.projects.firstWhereOrNull(
        (e) => e.id == info.projectId,
      );

      setState(() => _project = project);
    }

    if (info.section != null) {
      _controllerSection.text = info.section!;
    }

    if (info.floor != null) {
      _controllerFloor.text = info.floor!;
    }

    if (info.number != null) {
      _controllerNumber.text = info.number!;
    }

    if (info.type != null) {
      _controllerType.text = info.type!;
    }

    if (info.rooms != null) {
      _controllerRooms.text = info.rooms!;
    }

    if (info.bathrooms != null) {
      _controllerBathrooms.text = info.bathrooms!;
    }

    if (info.total != null) {
      _controllerTotal.text = info.total!;
    }

    if (info.living != null) {
      _controllerLiving.text = info.living!;
    }

    _controllerName.text = info.name;
    _validateName(info.name);

    if (info.description != null) {
      _controllerDescription.text = info.description!;
    }

    if (info.price != null) {
      _controllerPrice.text = info.price!;
      _validatePrice(info.price!);
    }

    if (info.depositVal != null) {
      _controllerDepositVal.text = info.depositVal!;
    }

    if (info.depositPct != null) {
      _controllerDepositPct.text = info.depositPct!;
    }

    if (info.period != null) {
      final CalculationPeriodModel period = _periods.firstWhere(
        (e) => e.month == info.period,
      );

      setState(() => _period = period);
    }

    if (info.startInstallments != null) {
      final Jiffy startInstallments = Jiffy.parse(
        info.startInstallments!,
        isUtc: true,
      );

      setState(() {
        _startInstallments = startInstallments.dateTime;
      });
    }

    if (info.endInstallments != null) {
      final Jiffy endInstallments = Jiffy.parse(
        info.endInstallments!,
        isUtc: true,
      );

      setState(() {
        _endInstallments = endInstallments.dateTime;
      });
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

  void _onSelectCompany({
    required String name,
    required List<CompanyModel> companies,
  }) {
    final CompanyModel company = companies.firstWhere(
      (e) => e.info.name == name,
    );

    setState(() => _company = company);
  }

  void _onSelectProject({
    required String name,
    required List<ProjectModel> projects,
  }) {
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

  void _validatePrice(String price) {
    setState(() {
      _priceValid = price.length > 5;
      _controllerDepositVal.clear();
      _controllerDepositPct.clear();
    });
  }

  String _getDepositValTitle() {
    final String price = _controllerPrice.text;

    if (price.isNotEmpty) {
      return 'First deposit in (${price[0]})';
    } else {
      return 'First deposit in (€)';
    }
  }

  void _validateDepositVal(String depositVal) {
    final bool isValid = depositVal.length > 3;

    if (isValid) {
      final int price = _parseString(_controllerPrice.text);
      final int deposit = _parseString(depositVal);

      final double depositPct = (deposit * 100) / price;

      _controllerDepositPct.text = depositPct.toStringAsFixed(0);
    } else {
      _controllerDepositPct.clear();
    }
  }

  void _validateDepositPct(String depositPct) {
    final bool isValid = depositPct.isNotEmpty;

    if (isValid) {
      final int price = _parseString(_controllerPrice.text);
      final int deposit = _parseString(depositPct);

      final double depositVal = (price * deposit) / 100;

      _controllerDepositVal.text = depositVal.toStringAsFixed(0);
    } else {
      _controllerDepositVal.clear();
    }
  }

  void _onSelectCalculationPeriod(String name) {
    final CalculationPeriodModel period = _periods.firstWhere(
      (e) => e.name == name,
    );

    setState(() => _period = period);
  }

  void _onSelectStartInstallments(DateTime installments) {
    setState(() => _startInstallments = installments);
  }

  void _onSelectEndInstallments(DateTime installments) {
    setState(() => _endInstallments = installments);
  }

  Future<void> _printPdf(ManageCalculationState state) async {
    final bool isPrinted = await Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (PdfPageFormat format) {
        return _generatePdf(
          format: format,
          state: state,
        );
      },
    );

    if (isPrinted) {
      // update counter
    }
  }

  Future<Uint8List> _generatePdf({
    required PdfPageFormat format,
    required ManageCalculationState state,
  }) async {
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
      _switchLoading(true);

      final pdf.Page projectInfo = await _getProjectInfo(
        format: format,
        state: state,
        stylePrimary: stylePrimary,
        styleSecondary: styleSecondary,
      );

      document.addPage(projectInfo);
    }

    final int? payments = _getPayments();

    if (payments != null) {
      _switchLoading(true);

      final pdf.MultiPage calculationInfo = await _getCalculationInfo(
        format: format,
        stylePrimary: stylePrimary,
        styleSecondary: styleSecondary,
      );

      document.addPage(calculationInfo);
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
                            state.userData!.info.phone ??
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
                            height: 280.0,
                            fit: pdf.BoxFit.cover,
                          ),
                        ),
                        if (projectImages.length > 1) ...[
                          pdf.SizedBox(width: 8.0),
                        ],
                        pdf.Column(
                          children: [
                            if (projectImages.length > 1) ...[
                              pdf.Image(
                                projectImages[1],
                                width: 180.0,
                                height: 136.0,
                                fit: pdf.BoxFit.cover,
                              ),
                            ],
                            pdf.SizedBox(height: 8.0),
                            if (projectImages.length > 2) ...[
                              pdf.Image(
                                projectImages[2],
                                width: 180.0,
                                height: 136.0,
                                fit: pdf.BoxFit.cover,
                              ),
                            ] else ...[
                              pdf.SizedBox(
                                width: 180.0,
                                height: 136.0,
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
                    maxLines: 8,
                  ),
                  pdf.SizedBox(height: 18.0),
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
                            data: '$total m2',
                            stylePrimary: stylePrimary,
                            styleSecondary: styleSecondary,
                          ),
                        ],
                        if (living.isNotEmpty) ...[
                          _getProjectFeatureItem(
                            title: 'Living area',
                            data: '$living m2',
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

  //todo: 2
  Future<pdf.MultiPage> _getCalculationInfo({
    required PdfPageFormat format,
    required pdf.TextStyle stylePrimary,
    required pdf.TextStyle styleSecondary,
  }) async {
    final String price = _controllerPrice.text.trim();

    final String depositVal = _controllerDepositVal.text.trim();
    final String depositPct = _controllerDepositPct.text.trim();
    final String firstDeposit = '${price[0]}$depositVal — $depositPct%';

    final int? payments = _getPayments();
    final String installmentPlan = '${_period!.name} — $payments payments';

    final Jiffy startInstallments = Jiffy.parseFromDateTime(
      _startInstallments!,
    );
    final Jiffy endInstallments = Jiffy.parseFromDateTime(
      _endInstallments!,
    );
    final String installmentTerms =
        '${startInstallments.yMMMMd} — ${endInstallments.yMMMMd}';

    return pdf.MultiPage(
      pageFormat: format,
      margin: const pdf.EdgeInsets.symmetric(
        horizontal: 42.0,
        vertical: 72.0,
      ),
      build: (pdf.Context context) {
        return [
          _getCalculationInfoItem(
            title: 'Unit price (without extra costs)',
            data: price,
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
          if (depositVal.isNotEmpty) ...[
            _getCalculationInfoItem(
              title: 'First deposit',
              data: firstDeposit,
              stylePrimary: stylePrimary,
              styleSecondary: styleSecondary,
            ),
          ],
          _getCalculationInfoItem(
            title: 'Installment plan',
            data: installmentPlan,
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
          _getCalculationInfoItem(
            title: 'Installment terms',
            data: installmentTerms,
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
        ];
      },
    );
  }

  int? _getPayments() {
    if (!_priceValid) return null;
    if (_period == null) return null;
    if (_startInstallments == null) return null;
    if (_endInstallments == null) return null;

    final Jiffy startInstallments = Jiffy.parseFromDateTime(
      _startInstallments!,
    );

    final Jiffy endInstallments = Jiffy.parseFromDateTime(
      _endInstallments!.add(const Duration(days: 1)),
    );

    final int difference =
        startInstallments.diff(endInstallments, unit: Unit.month).toInt();

    final int round = difference < 0 ? difference * -1 : 1;

    return round ~/ _period!.month;
  }

  int _parseString(String value) {
    final String formatValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(formatValue);
  }

  pdf.Padding _getCalculationInfoItem({
    required String title,
    required String data,
    required pdf.TextStyle stylePrimary,
    required pdf.TextStyle styleSecondary,
  }) {
    return pdf.Padding(
      padding: const pdf.EdgeInsets.only(
        bottom: 4.0,
      ),
      child: pdf.Row(
        children: [
          pdf.Text(
            '• $title: ',
            style: stylePrimary.copyWith(
              fontSize: 10.0,
            ),
          ),
          pdf.SizedBox(width: 2.0),
          pdf.Text(
            data,
            style: styleSecondary.copyWith(
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  void _createCalculation(BuildContext context) {
    _switchErrorName();

    if (widget.count > 18) {
      const String errorLimit =
          'The limit for creating calculations for the workspace has been reached';
      return _showErrorMessage(errorMessage: errorLimit);
    }

    final String section = _controllerSection.text.trim();
    final String floor = _controllerFloor.text.trim();
    final String number = _controllerNumber.text.trim();
    final String type = _controllerType.text.trim();
    final String rooms = _controllerRooms.text.trim();
    final String bathrooms = _controllerBathrooms.text.trim();
    final String total = _controllerTotal.text.trim();
    final String living = _controllerLiving.text.trim();
    final String name = _controllerName.text.trim();
    final String description = _controllerDescription.text.trim();

    final String price = _controllerPrice.text.trim();
    final String depositVal = _controllerDepositVal.text.trim();
    final String depositPct = _controllerDepositPct.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Calculation name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    context.read<ManageCalculationBloc>().add(
          CreateCalculation(
            companyId: _company?.id,
            projectId: _project?.id,
            section: section,
            floor: floor,
            number: number,
            type: type,
            rooms: rooms,
            bathrooms: bathrooms,
            total: total,
            living: living,
            name: name,
            description: description,
            price: price,
            depositVal: depositVal,
            depositPct: depositPct,
            period: _period?.month,
            startInstallments: _startInstallments,
            endInstallments: _endInstallments,
          ),
        );
  }

  void _updateCalculation(BuildContext context) {
    _switchErrorName();

    final String section = _controllerSection.text.trim();
    final String floor = _controllerFloor.text.trim();
    final String number = _controllerNumber.text.trim();
    final String type = _controllerType.text.trim();
    final String rooms = _controllerRooms.text.trim();
    final String bathrooms = _controllerBathrooms.text.trim();
    final String total = _controllerTotal.text.trim();
    final String living = _controllerLiving.text.trim();
    final String name = _controllerName.text.trim();
    final String description = _controllerDescription.text.trim();
    final String price = _controllerPrice.text.trim();
    final String depositVal = _controllerDepositVal.text.trim();
    final String depositPct = _controllerDepositPct.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Calculation name is too short';

      _switchErrorName(error: errorName);
      return _showErrorMessage(errorMessage: errorName);
    }

    context.read<ManageCalculationBloc>().add(
          UpdateCalculation(
            id: widget.calculation!.id,
            companyId: _company?.id,
            projectId: _project?.id,
            section: section,
            floor: floor,
            number: number,
            type: type,
            rooms: rooms,
            bathrooms: bathrooms,
            total: total,
            living: living,
            name: name,
            description: description,
            price: price,
            depositVal: depositVal,
            depositPct: depositPct,
            period: _period?.month,
            startInstallments: _startInstallments,
            endInstallments: _endInstallments,
            createdAt: widget.calculation!.metadata.createdAt,
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
              title: widget.calculation == null
                  ? 'Calculation successfully created'
                  : 'Calculation successfully updated',
              type: InAppNotificationType.success,
            );

            widget.navigateToCalculationsPage();
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
                          initialData: _company?.info.name,
                          labelText: 'Company',
                          hintText: 'Select company',
                          values:
                              state.companies.map((e) => e.info.name).toList(),
                          onChanged: (String name) => _onSelectCompany(
                            name: name,
                            companies: state.companies,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                      AnimatedDropdown(
                        initialData: _project?.info.name,
                        labelText: 'Project',
                        hintText: 'Select project',
                        values: state.projects.map((e) => e.info.name).toList(),
                        onChanged: (String name) => _onSelectProject(
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
                              labelText: 'Total area (m2)',
                              hintText: 'Enter area',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
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
                              labelText: 'Living area (m2)',
                              hintText: 'Enter area',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
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
                        LengthLimitingTextInputFormatter(64),
                      ],
                      onChanged: _validateName,
                    ),
                    const SizedBox(height: 16.0),
                    BorderTextField(
                      controller: _controllerDescription,
                      labelText: 'Description',
                      hintText: 'Field for notes, explanations, etc..',
                      maxLines: 6,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1024),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    BorderTextField(
                      controller: _controllerPrice,
                      labelText: 'Unit price (without extra costs)',
                      hintText: 'Example: €100000',
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[€£¥₽₹$]\d*$'),
                        ),
                      ],
                      onChanged: _validatePrice,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: BorderTextField(
                            controller: _controllerDepositVal,
                            enabled: _priceValid,
                            labelText: _getDepositValTitle(),
                            hintText: 'Enter value',
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: _validateDepositVal,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: BorderTextField(
                            controller: _controllerDepositPct,
                            enabled: _priceValid,
                            labelText: 'First deposit in (%)',
                            hintText: 'Enter percent',
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: _validateDepositPct,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    AnimatedDropdown(
                      initialData: _period?.name,
                      labelText: 'Calculation period',
                      hintText: 'Select period',
                      values: _periods.map((e) => e.name).toList(),
                      onChanged: _onSelectCalculationPeriod,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDatePicker(
                            addDay: false,
                            initialDate: _startInstallments,
                            lastDate: _endInstallments,
                            labelText: 'Start of installments',
                            hintFormat: 'dd/MM/yy',
                            onChanged: _onSelectStartInstallments,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: CustomDatePicker(
                            addDay: true,
                            initialDate: _endInstallments,
                            firstDate: _startInstallments,
                            labelText: 'End of installments',
                            hintFormat: 'dd/MM/yy',
                            onChanged: _onSelectEndInstallments,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    CustomTextButton(
                      text: 'Print Pdf',
                      onTap: () => _printPdf(state),
                    ),
                    const SizedBox(height: 12.0),
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
    return const SizedBox();
  }
}
