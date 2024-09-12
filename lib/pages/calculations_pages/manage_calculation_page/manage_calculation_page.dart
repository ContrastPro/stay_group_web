import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../models/calculations/calculation_extra_model.dart';
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
import '../../../resources/app_text_styles.dart';
import '../../../services/in_app_notification_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../widgets/animations/action_loader.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/data_pickers/custom_date_picker.dart';
import '../../../widgets/dropdowns/animated_dropdown.dart';
import '../../../widgets/dropdowns/icon_dropdown.dart';
import '../../../widgets/layouts/preview_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/modals/modal_dialog.dart';
import '../../../widgets/text_fields/border_text_field.dart';
import 'blocs/manage_calculation_bloc/manage_calculation_bloc.dart';
import 'widgets/manage_calculation_extra_item.dart';
import 'widgets/manage_calculation_extra_modal_dialog.dart';
import 'widgets/pdf_generate_document.dart';

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
  final List<CalculationExtraModel> _extra = [];
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
  bool _calculationValid = false;

  CompanyModel? _company;
  ProjectModel? _project;
  String? _errorTextName;
  String? _currency;
  CalculationPeriodModel? _period;
  DateTime? _startInstallments;
  DateTime? _endInstallments;

  void _setInitialData(ManageCalculationState state) {
    if (_dataLoaded) return;

    if (widget.calculation == null) {
      _currency = kCurrencies.first;
      return _switchDataLoaded(true);
    }

    final CalculationInfoModel info = widget.calculation!.info;

    if (info.companyId != null) {
      final CompanyModel? company = state.companies.firstWhereOrNull(
        (e) => e.id == info.companyId,
      );

      _company = company;
    }

    if (info.projectId != null) {
      final ProjectModel? project = state.projects.firstWhereOrNull(
        (e) => e.id == info.projectId,
      );

      _project = project;
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

    _currency = info.currency;

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
      final CalculationPeriodModel period = kPeriods.firstWhere(
        (e) => e.month == info.period,
      );

      _period = period;
    }

    if (info.startInstallments != null) {
      final DateTime startInstallments = DateTime.parse(
        info.startInstallments!,
      );

      _startInstallments = startInstallments;
    }

    if (info.endInstallments != null) {
      final DateTime endInstallments = DateTime.parse(
        info.endInstallments!,
      );

      _endInstallments = endInstallments;
    }

    if (info.extra != null) {
      _extra.addAll(info.extra!);
    }

    _validateCalculation();
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
    setState(() => _nameValid = name.length > 1);
  }

  void _onSelectCurrency(String currency) {
    setState(() => _currency = currency);
  }

  void _validatePrice(String price) {
    _priceValid = price.length > 4;
    _controllerDepositVal.clear();
    _controllerDepositPct.clear();
    _validateCalculation();
  }

  void _validateDepositVal(String depositVal) {
    final bool isValid = depositVal.length > 3;

    if (isValid) {
      final int price = parseString(_controllerPrice.text);
      final int deposit = parseString(depositVal);

      final double depositPct = (deposit * 100) / price;

      _controllerDepositPct.text = depositPct.toStringAsFixed(0);
    } else {
      _controllerDepositPct.clear();
    }
  }

  void _validateDepositPct(String depositPct) {
    final bool isValid = depositPct.isNotEmpty;

    if (isValid) {
      final int price = parseString(_controllerPrice.text);
      final int deposit = parseString(depositPct);

      final double depositVal = (price * deposit) / 100;

      _controllerDepositVal.text = depositVal.toStringAsFixed(0);
    } else {
      _controllerDepositVal.clear();
    }
  }

  void _onSelectCalculationPeriod(String name) {
    final CalculationPeriodModel period = kPeriods.firstWhere(
      (e) => e.name == name,
    );

    _period = period;

    _validateCalculation();
  }

  void _onSelectStartInstallments(DateTime startInstallments) {
    _startInstallments = startInstallments;
    _validateCalculation();
  }

  void _onSelectEndInstallments(DateTime endInstallments) {
    _endInstallments = endInstallments;
    _validateCalculation();
  }

  void _validateCalculation() {
    final bool calculationValid = _priceValid &&
        _period != null &&
        _startInstallments != null &&
        _endInstallments != null;

    setState(() => _calculationValid = calculationValid);
  }

  Future<void> _printPdf(ManageCalculationState state) async {
    final String section = _controllerSection.text.trim();
    final String floor = _controllerFloor.text.trim();
    final String number = _controllerNumber.text.trim();
    final String type = _controllerType.text.trim();
    final String rooms = _controllerRooms.text.trim();
    final String bathrooms = _controllerBathrooms.text.trim();
    final String total = _controllerTotal.text.trim();
    final String living = _controllerLiving.text.trim();
    final String depositVal = _controllerDepositVal.text.trim();
    final String depositPct = _controllerDepositPct.text.trim();

    final bool isPrinted = await Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (PdfPageFormat format) {
        return pdfGenerateDocument(
          format: format,
          state: state,
          company: _company,
          project: _project,
          section: section,
          floor: floor,
          number: number,
          type: type,
          rooms: rooms,
          bathrooms: bathrooms,
          total: total,
          living: living,
          calculationValid: _calculationValid,
          currency: _currency,
          depositVal: depositVal,
          depositPct: depositPct,
          period: _period,
          startInstallments: _startInstallments,
          endInstallments: _endInstallments,
          extra: _extra,
          switchLoading: _switchLoading,
          getPrice: _getPrice,
          getRemainingPrice: _getRemainingPrice,
          getPaymentsCount: _getPaymentsCount,
          getPayment: _getPayment,
          getPaymentsDates: _getPaymentsDates,
        );
      },
    );

    if (isPrinted) {
      // update counter
    }
  }

  int? _getPrice() {
    if (!_priceValid) return null;
    final int price = parseString(_controllerPrice.text);
    return price;
  }

  int? _getRemainingPrice() {
    final int? price = _getPrice();
    if (price == null) return null;

    final String depositVal = _controllerDepositVal.text;

    if (depositVal.isNotEmpty) {
      final int deposit = parseString(depositVal);
      return price - deposit;
    }

    return price;
  }

  int? _getPaymentsCount() {
    if (_period == null) return null;
    if (_startInstallments == null) return null;
    if (_endInstallments == null) return null;

    final Jiffy startInstallments = Jiffy.parseFromDateTime(
      _startInstallments!,
    );

    final Jiffy endInstallments = Jiffy.parseFromDateTime(
      _endInstallments!.add(const Duration(days: 1)),
    );

    final num differenceNum = startInstallments.diff(
      endInstallments,
      unit: Unit.month,
    );

    final int differenceInt = differenceNum.toInt();
    if (differenceInt == 0) return differenceInt;

    final int differenceRound = differenceInt < 0 ? differenceInt * -1 : 0;
    final int difference = differenceRound ~/ _period!.month;

    return difference;
  }

  int? _getPayment() {
    final int? remainingPrice = _getRemainingPrice();
    if (remainingPrice == null) return null;

    final int? paymentsCount = _getPaymentsCount();
    if (paymentsCount == null) return null;

    if (remainingPrice > 0 && paymentsCount > 0) {
      return (remainingPrice / paymentsCount).round();
    }

    return 0;
  }

  List<DateTime>? _getPaymentsDates() {
    final int? paymentsCount = _getPaymentsCount();
    if (paymentsCount == null) return null;

    final List<DateTime> dates = [];

    final DateTime startInstallments = _startInstallments!;

    for (int i = 0; i < paymentsCount; i++) {
      final int index = _period!.month * i;

      dates.add(
        DateTime(
          startInstallments.year,
          startInstallments.month + index,
          startInstallments.day,
        ),
      );
    }

    return dates;
  }

  Future<void> _showManageExtraModal([
    CalculationExtraModel? calculationExtra,
  ]) async {
    if (!_calculationValid) return;

    final int? price = _getPrice();

    final List<DateTime>? paymentsDates = _getPaymentsDates();
    if (paymentsDates!.isEmpty) return;

    await ModalDialog.show(
      context: context,
      builder: (ctx) => ManageCalculationExtraModalDialog(
        currency: _currency!,
        price: price!,
        paymentsDates: paymentsDates,
        calculationExtra: calculationExtra,
        onCancel: ctx.pop,
        onCreate: (CalculationExtraModel extra) => _createCalculationExtra(
          context: ctx,
          extra: extra,
        ),
        onUpdate: (CalculationExtraModel extra) => _updateCalculationExtra(
          context: ctx,
          extra: extra,
        ),
        onDelete: (CalculationExtraModel extra) => _deleteCalculationExtra(
          context: ctx,
          extra: extra,
        ),
      ),
    );
  }

  void _createCalculationExtra({
    required BuildContext context,
    required CalculationExtraModel extra,
  }) {
    setState(() => _extra.add(extra));
    context.pop();
  }

  void _updateCalculationExtra({
    required BuildContext context,
    required CalculationExtraModel extra,
  }) {
    final int index = _extra.indexWhere((e) => e.id == extra.id);
    setState(() => _extra[index] = extra);
    context.pop();
  }

  void _deleteCalculationExtra({
    required BuildContext context,
    required CalculationExtraModel extra,
  }) {
    final int index = _extra.indexWhere((e) => e.id == extra.id);
    setState(() => _extra.removeAt(index));
    context.pop();
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
            currency: _currency!,
            price: price,
            depositVal: depositVal,
            depositPct: depositPct,
            period: _period?.month,
            startInstallments: _startInstallments,
            endInstallments: _endInstallments,
            extra: _extra,
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
            currency: _currency!,
            price: price,
            depositVal: depositVal,
            depositPct: depositPct,
            period: _period?.month,
            startInstallments: _startInstallments,
            endInstallments: _endInstallments,
            extra: _extra,
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
                      labelText: 'Calculation notes',
                      hintText: 'Field for notes, clients info, etc..',
                      maxLines: 14,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1024),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        IconDropdown(
                          initialData: _currency!,
                          values: kCurrencies,
                          labelText: 'Currency',
                          onChanged: _onSelectCurrency,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: BorderTextField(
                            controller: _controllerPrice,
                            labelText: 'Unit price',
                            hintText: 'Enter value',
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: _validatePrice,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: BorderTextField(
                            controller: _controllerDepositVal,
                            enabled: _priceValid,
                            labelText: 'First deposit in ($_currency)',
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
                      values: kPeriods.map((e) => e.name).toList(),
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
                    const SizedBox(height: 28.0),
                    Text(
                      'Extra expense',
                      style: AppTextStyles.paragraphLMedium,
                    ),
                    const SizedBox(height: 16.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _extra.length,
                      itemBuilder: (_, int i) {
                        return ManageCalculationExtraItem(
                          currency: _currency!,
                          calculationExtra: _extra[i],
                          onManage: _showManageExtraModal,
                        );
                      },
                    ),
                    CustomTextButton(
                      prefixIcon: AppIcons.add,
                      text: 'Add extra expense',
                      onTap: _showManageExtraModal,
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
