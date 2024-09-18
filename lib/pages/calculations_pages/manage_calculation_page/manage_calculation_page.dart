import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../models/calculations/calculation_extra_model.dart';
import '../../../models/calculations/calculation_info_model.dart';
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
import '../../../widgets/buttons/custom_icon_button.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/data_pickers/custom_date_picker.dart';
import '../../../widgets/dropdowns/animated_dropdown.dart';
import '../../../widgets/dropdowns/icon_dropdown.dart';
import '../../../widgets/layouts/preview_layout.dart';
import '../../../widgets/loaders/cached_network_image_loader.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/modals/modal_dialog.dart';
import '../../../widgets/text_fields/custom_text_field.dart';
import 'blocs/manage_calculation_bloc/manage_calculation_bloc.dart';
import 'widgets/manage_calculation_extra_item.dart';
import 'widgets/manage_calculation_extra_modal_dialog.dart';
import 'widgets/pdf_generate_document.dart';

class ManageCalculationPage extends StatefulWidget {
  const ManageCalculationPage({
    super.key,
    this.id,
    required this.navigateToCalculationsPage,
  });

  static const routePath = '/calculations_pages/manage_calculation';

  final String? id;
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

    if (state.calculation == null) {
      _currency = kCurrencies.first;
      return _switchDataLoaded(true);
    }

    final CalculationInfoModel info = state.calculation!.info;

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
      final int price = parseStringInt(_controllerPrice.text);
      final int deposit = parseStringInt(depositVal);

      final double depositPct = (deposit * 100) / price;

      _controllerDepositPct.text = depositPct.toStringAsFixed(0);
    } else {
      _controllerDepositPct.clear();
    }

    _updateState();
  }

  void _validateDepositPct(String depositPct) {
    final bool isValid = depositPct.isNotEmpty;

    if (isValid) {
      final int price = parseStringInt(_controllerPrice.text);
      final int deposit = parseStringInt(depositPct);

      final double depositVal = (price * deposit) / 100;

      _controllerDepositVal.text = depositVal.toStringAsFixed(0);
    } else {
      _controllerDepositVal.clear();
    }

    _updateState();
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

  void _updateState([String? value]) {
    setState(() {});
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

    setState(() {
      _extra.sort(
        (a, b) => a.date.compareTo(b.date),
      );
    });
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

  Future<void> _printPdf(ManageCalculationState state) async {
    _switchLoading(true);

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

    await Printing.layoutPdf(
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
          getPrice: _getPrice,
          getPaymentsCount: _getPaymentsCount,
          getPayment: _getPayment,
          getPaymentsDates: _getPaymentsDates,
        );
      },
    );

    _switchLoading(false);
  }

  int? _getPrice() {
    if (!_priceValid) return null;
    final int price = parseStringInt(_controllerPrice.text);
    return price;
  }

  int? _getRemainingPrice() {
    final int? price = _getPrice();
    if (price == null) return null;

    final String depositVal = _controllerDepositVal.text;

    if (depositVal.isNotEmpty) {
      final int deposit = parseStringInt(depositVal);
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
      _endInstallments!,
    );

    final num differenceNum = startInstallments.diff(
      endInstallments,
      unit: Unit.month,
    );

    final int differenceInt = differenceNum.toInt();

    final int differenceRound = differenceInt < 0 ? differenceInt * -1 : 0;

    final int difference = differenceRound ~/ _period!.month;

    return difference + 1;
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

  void _createCalculation({
    required BuildContext context,
    required ManageCalculationState state,
  }) {
    _switchErrorName();

    if (state.calculations.length > 18) {
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
          Init(
            id: widget.id,
          ),
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
              title: state.calculation == null
                  ? 'Calculation successfully created'
                  : 'Calculation successfully updated',
              type: InAppNotificationType.success,
            );

            if (state.calculation == null) {
              widget.navigateToCalculationsPage();
            }
          }
        },
        builder: (context, state) {
          if (_dataLoaded) {
            return ActionLoader(
              isLoading: _isLoading,
              child: PreviewLayout(
                content: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 42.0,
                  ),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomIconButton(
                          icon: AppIcons.arrowBack,
                          iconColor: AppColors.primary,
                          backgroundColor: AppColors.scaffoldSecondary,
                          splashColor: AppColors.scaffoldPrimary,
                          onTap: widget.navigateToCalculationsPage,
                        ),
                        const SizedBox(height: 4.0),
                      ],
                    ),
                    Text(
                      state.calculation == null
                          ? 'Add new calculation'
                          : 'Edit calculation',
                      style: AppTextStyles.head5SemiBold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      state.calculation == null
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
                            child: CustomTextField(
                              controller: _controllerSection,
                              labelText: 'Section',
                              hintText: 'Block or section',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(32),
                              ],
                              onChanged: _updateState,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: CustomTextField(
                              controller: _controllerFloor,
                              labelText: 'Floor',
                              hintText: 'Floor apartment',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: _updateState,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _controllerNumber,
                              labelText: 'Unit number',
                              hintText: 'Enter number',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(32),
                              ],
                              onChanged: _updateState,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: CustomTextField(
                              controller: _controllerType,
                              labelText: 'Unit type',
                              hintText: 'Enter type',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(32),
                              ],
                              onChanged: _updateState,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _controllerRooms,
                              labelText: 'Rooms',
                              hintText: 'Number of rooms',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: _updateState,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: CustomTextField(
                              controller: _controllerBathrooms,
                              labelText: 'Bathrooms',
                              hintText: 'Number of bathrooms',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: _updateState,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _controllerTotal,
                              labelText: 'Total area (m2)',
                              hintText: 'Enter area',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*'),
                                ),
                              ],
                              onChanged: _updateState,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: CustomTextField(
                              controller: _controllerLiving,
                              labelText: 'Living area (m2)',
                              hintText: 'Enter area',
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*'),
                                ),
                              ],
                              onChanged: _updateState,
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
                    CustomTextField(
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
                    CustomTextField(
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
                          child: CustomTextField(
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
                          child: CustomTextField(
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
                          child: CustomTextField(
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
                            hintFormat: kDatePattern,
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
                            hintFormat: kDatePattern,
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
                    if (state.calculation == null) ...[
                      CustomButton(
                        text: 'Create calculation',
                        onTap: () => _createCalculation(
                          context: context,
                          state: state,
                        ),
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
                  state: state,
                  company: _company,
                  project: _project,
                  section: _controllerSection.text,
                  floor: _controllerFloor.text,
                  number: _controllerNumber.text,
                  type: _controllerType.text,
                  rooms: _controllerRooms.text,
                  bathrooms: _controllerBathrooms.text,
                  total: _controllerTotal.text,
                  living: _controllerLiving.text,
                  calculationValid: _calculationValid,
                  currency: _currency,
                  depositVal: _controllerDepositVal.text,
                  depositPct: _controllerDepositPct.text,
                  period: _period,
                  startInstallments: _startInstallments,
                  endInstallments: _endInstallments,
                  extra: _extra,
                  getPrice: _getPrice,
                  getPaymentsCount: _getPaymentsCount,
                  getPayment: _getPayment,
                  getPaymentsDates: _getPaymentsDates,
                  onPrint: _printPdf,
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
    required this.state,
    this.company,
    this.project,
    required this.section,
    required this.floor,
    required this.number,
    required this.type,
    required this.rooms,
    required this.bathrooms,
    required this.total,
    required this.living,
    required this.calculationValid,
    this.currency,
    required this.depositVal,
    required this.depositPct,
    this.period,
    this.startInstallments,
    this.endInstallments,
    required this.extra,
    required this.getPrice,
    required this.getPaymentsCount,
    required this.getPayment,
    required this.getPaymentsDates,
    required this.onPrint,
  });

  final ManageCalculationState state;
  final CompanyModel? company;
  final ProjectModel? project;
  final String section;
  final String floor;
  final String number;
  final String type;
  final String rooms;
  final String bathrooms;
  final String total;
  final String living;
  final bool calculationValid;
  final String? currency;
  final String depositVal;
  final String depositPct;
  final CalculationPeriodModel? period;
  final DateTime? startInstallments;
  final DateTime? endInstallments;
  final List<CalculationExtraModel> extra;
  final int? Function() getPrice;
  final int? Function() getPaymentsCount;
  final int? Function() getPayment;
  final List<DateTime>? Function() getPaymentsDates;
  final void Function(ManageCalculationState) onPrint;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 42.0,
          ),
          child: Column(
            children: [
              _ProjectInfo(
                state: state,
                company: company,
                project: project,
                section: section,
                floor: floor,
                number: number,
                type: type,
                rooms: rooms,
                bathrooms: bathrooms,
                total: total,
                living: living,
              ),
              if (calculationValid) ...[
                const SizedBox(height: 12.0),
                _CalculationInfo(
                  project: project,
                  currency: currency,
                  depositVal: depositVal,
                  depositPct: depositPct,
                  period: period,
                  startInstallments: startInstallments,
                  endInstallments: endInstallments,
                  extra: extra,
                  getPrice: getPrice,
                  getPaymentsCount: getPaymentsCount,
                  getPayment: getPayment,
                  getPaymentsDates: getPaymentsDates,
                ),
              ],
            ],
          ),
        ),
        Positioned(
          left: 16.0,
          bottom: 16.0,
          child: CustomIconButton(
            icon: AppIcons.print,
            addBorder: false,
            onTap: () => onPrint(state),
          ),
        ),
      ],
    );
  }
}

class _ProjectInfo extends StatelessWidget {
  const _ProjectInfo({
    required this.state,
    this.company,
    this.project,
    required this.section,
    required this.floor,
    required this.number,
    required this.type,
    required this.rooms,
    required this.bathrooms,
    required this.total,
    required this.living,
  });

  final ManageCalculationState state;
  final CompanyModel? company;
  final ProjectModel? project;
  final String section;
  final String floor;
  final String number;
  final String type;
  final String rooms;
  final String bathrooms;
  final String total;
  final String living;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 640.0,
      height: 940.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 42.0,
        vertical: 72.0,
      ),
      color: AppColors.scaffoldSecondary,
      child: Column(
        children: [
          _ProjectHeader(
            state: state,
          ),
          _ProjectContent(
            project: project,
            section: section,
            floor: floor,
            number: number,
            type: type,
            rooms: rooms,
            bathrooms: bathrooms,
            total: total,
            living: living,
          ),
          _ProjectFooter(
            company: company,
          ),
        ],
      ),
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  const _ProjectHeader({
    required this.state,
  });

  final ManageCalculationState state;

  String _getUserContact() {
    return state.userData!.info.phone ?? state.userData!.credential.email;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 22.0,
      ),
      color: AppColors.iconPrimary,
      child: Row(
        children: [
          if (state.spaceData != null) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.spaceData!.info.name,
                    style: AppTextStyles.paragraphMMedium.copyWith(
                      color: AppColors.scaffoldSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    state.userData!.info.name,
                    style: AppTextStyles.paragraphMMedium.copyWith(
                      color: AppColors.scaffoldSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _getUserContact(),
                    style: AppTextStyles.captionRegular.copyWith(
                      color: AppColors.scaffoldSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ] else ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.userData!.info.name,
                    style: AppTextStyles.paragraphMMedium.copyWith(
                      color: AppColors.scaffoldSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    state.userData!.credential.email,
                    style: AppTextStyles.captionRegular.copyWith(
                      color: AppColors.scaffoldSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProjectContent extends StatelessWidget {
  const _ProjectContent({
    this.project,
    required this.section,
    required this.floor,
    required this.number,
    required this.type,
    required this.rooms,
    required this.bathrooms,
    required this.total,
    required this.living,
  });

  final ProjectModel? project;
  final String section;
  final String floor;
  final String number;
  final String type;
  final String rooms;
  final String bathrooms;
  final String total;
  final String living;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (project != null) ...[
            const SizedBox(height: 8.0),
            if (project!.info.media != null) ...[
              SizedBox(
                width: double.infinity,
                height: 300.0,
                child: Row(
                  children: [
                    Expanded(
                      child: CachedNetworkImageLoader(
                        imageUrl: project!.info.media![0].data,
                      ),
                    ),
                    if (project!.info.media!.length > 1) ...[
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 200.0,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 146.0,
                              child: CachedNetworkImageLoader(
                                imageUrl: project!.info.media![1].data,
                              ),
                            ),
                            if (project!.info.media!.length > 2) ...[
                              const SizedBox(height: 8.0),
                              SizedBox(
                                height: 146.0,
                                child: CachedNetworkImageLoader(
                                  imageUrl: project!.info.media![2].data,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
            ],
            Text(
              project!.info.name,
              style: AppTextStyles.paragraphMSemiBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                const SizedBox(width: 4.0),
                Flexible(
                  child: Text(
                    project!.info.location,
                    style: AppTextStyles.captionRegular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              project!.info.description,
              style: AppTextStyles.captionRegular,
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 18.0),
            Expanded(
              child: GridView.count(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                childAspectRatio: 2.0,
                children: [
                  if (section.isNotEmpty) ...[
                    _ProjectFeatureItem(
                      title: 'Section',
                      data: section,
                    ),
                  ],
                  if (floor.isNotEmpty) ...[
                    _ProjectFeatureItem(
                      title: 'Floor',
                      data: floor,
                    ),
                  ],
                  if (number.isNotEmpty) ...[
                    _ProjectFeatureItem(
                      title: 'Unit number',
                      data: number,
                    ),
                  ],
                  if (type.isNotEmpty) ...[
                    _ProjectFeatureItem(
                      title: 'Unit type',
                      data: type,
                    ),
                  ],
                  if (rooms.isNotEmpty) ...[
                    _ProjectFeatureItem(
                      title: 'Rooms',
                      data: rooms,
                    ),
                  ],
                  if (bathrooms.isNotEmpty) ...[
                    _ProjectFeatureItem(
                      title: 'Bathrooms',
                      data: bathrooms,
                    ),
                  ],
                  if (total.isNotEmpty) ...[
                    _ProjectFeatureItem(
                      title: 'Total area',
                      data: '$total m2',
                    ),
                  ],
                  if (living.isNotEmpty) ...[
                    _ProjectFeatureItem(
                      title: 'Living area',
                      data: '$living m2',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProjectFeatureItem extends StatelessWidget {
  const _ProjectFeatureItem({
    required this.title,
    required this.data,
  });

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.captionMedium,
          ),
          Text(
            data,
            style: AppTextStyles.captionRegular.copyWith(
              fontSize: 10.0,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ProjectFooter extends StatelessWidget {
  const _ProjectFooter({
    this.company,
  });

  final CompanyModel? company;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 22.0,
      ),
      color: AppColors.iconPrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (company != null) ...[
            Text(
              'About company',
              style: AppTextStyles.captionMedium.copyWith(
                fontSize: 10.0,
                color: AppColors.scaffoldSecondary,
              ),
            ),
            const SizedBox(height: 1.5),
            Text(
              '${company!.info.name}. ${company!.info.description}',
              style: AppTextStyles.captionRegular.copyWith(
                fontSize: 8.0,
                color: AppColors.scaffoldSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ] else ...[
            Text(
              'www.staygroup.space',
              style: AppTextStyles.captionMedium.copyWith(
                fontSize: 10.0,
                color: AppColors.scaffoldSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CalculationInfo extends StatelessWidget {
  const _CalculationInfo({
    this.project,
    this.currency,
    required this.depositVal,
    required this.depositPct,
    this.period,
    this.startInstallments,
    this.endInstallments,
    required this.extra,
    required this.getPrice,
    required this.getPaymentsCount,
    required this.getPayment,
    required this.getPaymentsDates,
  });

  final ProjectModel? project;
  final String? currency;
  final String depositVal;
  final String depositPct;
  final CalculationPeriodModel? period;
  final DateTime? startInstallments;
  final DateTime? endInstallments;
  final List<CalculationExtraModel> extra;
  final int? Function() getPrice;
  final int? Function() getPaymentsCount;
  final int? Function() getPayment;
  final List<DateTime>? Function() getPaymentsDates;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 640.0,
      height: 940.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 42.0,
        vertical: 72.0,
      ),
      color: AppColors.scaffoldSecondary,
      child: _calculationInfoContent(),
    );
  }

  Widget _calculationInfoContent() {
    final int? price = getPrice();
    final int? paymentsCount = getPaymentsCount();
    final int? payment = getPayment();

    final DateFormat dateFormat = DateFormat.yMMMMd();
    final String start = dateFormat.format(startInstallments!);
    final String end = dateFormat.format(endInstallments!);

    int totalPrice = price!;

    for (int i = 0; i < extra.length; i++) {
      totalPrice = totalPrice + parseStringInt(extra[i].priceVal);
    }

    final List<Widget> calculations = _getCalculations(
      paymentsCount: paymentsCount!,
      payment: payment!,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project != null
              ? 'Calculations for ${project!.info.name}'
              : 'Calculations',
          style: AppTextStyles.paragraphMSemiBold,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6.0),
        _calculationInfoItem(
          title: 'Unit price',
          data: '$currency$price',
        ),
        if (depositVal.isNotEmpty) ...[
          _calculationInfoItem(
            title: 'First deposit',
            data: '$currency$depositVal — $depositPct%',
          ),
        ],
        if (payment > 0) ...[
          _calculationInfoItem(
            title: 'Installment plan',
            data:
                '${period!.name}(~$currency$payment) — $paymentsCount payment(s)',
          ),
          _calculationInfoItem(
            title: 'Installment terms',
            data: '$start — $end',
          ),
          if (price != totalPrice) ...[
            _calculationInfoItem(
              title: 'Total price (Unit price + Taxes and fees)',
              data: '$currency$totalPrice',
            ),
          ],
          const SizedBox(height: 12.0),
          _calculationItem(
            addColor: true,
            number: '№',
            date: 'Payment date',
            total: 'Total',
            payment: 'Installments',
            extraPrice: 'Taxes and fees',
            extraDescription: 'Description',
          ),
          ...calculations,
        ],
      ],
    );
  }

  List<Widget> _getCalculations({
    required int paymentsCount,
    required int payment,
  }) {
    final List<Widget> calculations = [];

    if (payment > 0) {
      final DateFormat dateFormat = DateFormat(kDatePattern);
      final List<DateTime>? paymentsDates = getPaymentsDates();

      for (int i = 0; i < paymentsCount; i++) {
        final DateTime paymentDate = paymentsDates![i];

        int extraPrice = 0;
        String extraDescription = '';

        for (int y = 0; y < extra.length; y++) {
          final CalculationExtraModel calculationExtra = extra[y];

          if (calculationExtra.date.isAtSameMomentAs(paymentDate)) {
            extraPrice = extraPrice + parseStringInt(calculationExtra.priceVal);

            extraDescription = extraDescription.isNotEmpty
                ? '$extraDescription; ${calculationExtra.name}'
                : calculationExtra.name;
          }
        }

        calculations.add(
          _calculationItem(
            number: '${i + 1}',
            date: dateFormat.format(paymentDate),
            total: '$currency${payment + extraPrice}',
            payment: '$currency$payment',
            extraPrice: '$currency$extraPrice',
            extraDescription: extraDescription,
          ),
        );
      }

      const int kMaxPreviewLength = 25;

      if (calculations.length > kMaxPreviewLength) {
        const String kCropPattern = '...';
        final List<Widget> croppedCalculations = [];

        final List<Widget> firstRange =
            calculations.getRange(0, kMaxPreviewLength - 4).toList();

        final List<Widget> secondRange = calculations
            .getRange(calculations.length - 4, calculations.length)
            .toList();

        croppedCalculations.addAll(firstRange);

        croppedCalculations.add(
          _calculationItem(
            number: kCropPattern,
            date: kCropPattern,
            total: kCropPattern,
            payment: kCropPattern,
            extraPrice: kCropPattern,
            extraDescription: kCropPattern,
          ),
        );

        croppedCalculations.addAll(secondRange);

        return croppedCalculations;
      }

      return calculations;
    }

    return calculations;
  }

  Widget _calculationItem({
    bool addColor = false,
    required String number,
    required String date,
    required String total,
    required String payment,
    required String extraPrice,
    required String extraDescription,
  }) {
    return Container(
      height: 24.0,
      decoration: BoxDecoration(
        color: addColor ? AppColors.iconPrimary : null,
        border: !addColor
            ? const Border(
                bottom: BorderSide(
                  color: AppColors.iconPrimary,
                  width: 0.6,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.0,
            child: Text(
              number,
              style: AppTextStyles.captionRegular.copyWith(
                fontSize: 8.0,
                color: addColor ? AppColors.scaffoldSecondary : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 15,
            child: Text(
              date,
              style: AppTextStyles.captionRegular.copyWith(
                fontSize: 8.0,
                color: addColor ? AppColors.scaffoldSecondary : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 15,
            child: Text(
              total,
              style: AppTextStyles.captionRegular.copyWith(
                fontSize: 8.0,
                color: addColor ? AppColors.scaffoldSecondary : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 15,
            child: Text(
              payment,
              style: AppTextStyles.captionRegular.copyWith(
                fontSize: 8.0,
                color: addColor ? AppColors.scaffoldSecondary : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 20,
            child: Text(
              extraPrice,
              style: AppTextStyles.captionRegular.copyWith(
                fontSize: 8.0,
                color: addColor ? AppColors.scaffoldSecondary : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 35,
            child: Text(
              extraDescription.isNotEmpty ? extraDescription : '—',
              style: AppTextStyles.captionRegular.copyWith(
                fontSize: addColor ? 8.0 : 6.0,
                color: addColor ? AppColors.scaffoldSecondary : null,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.iconPrimary,
                    width: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6.0),
        ],
      ),
    );
  }

  Widget _calculationInfoItem({
    required String title,
    required String data,
  }) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 4.0,
        ),
        child: Row(
          children: [
            Flexible(
              child: Text(
                '• $title: ',
                style: AppTextStyles.captionMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 2.0),
            Flexible(
              child: Text(
                data,
                style: AppTextStyles.captionRegular,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
