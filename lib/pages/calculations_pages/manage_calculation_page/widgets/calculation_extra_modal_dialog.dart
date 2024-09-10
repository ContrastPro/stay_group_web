import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../models/calculations/calculation_date_model.dart';
import '../../../../models/calculations/calculation_extra_model.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_icons.dart';
import '../../../../utils/helpers.dart';
import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/buttons/custom_text_button.dart';
import '../../../../widgets/dropdowns/animated_dropdown.dart';
import '../../../../widgets/text_fields/border_text_field.dart';

class CalculationExtraModalDialog extends StatefulWidget {
  const CalculationExtraModalDialog({
    super.key,
    required this.currency,
    required this.price,
    required this.paymentsDates,
    this.calculationExtra,
    required this.onCancel,
    required this.onCreate,
    required this.onUpdate,
    required this.onDelete,
  });

  final String currency;
  final int price;
  final List<DateTime> paymentsDates;
  final CalculationExtraModel? calculationExtra;
  final void Function() onCancel;
  final void Function(CalculationExtraModel) onCreate;
  final void Function(CalculationExtraModel) onUpdate;
  final void Function(CalculationExtraModel) onDelete;

  @override
  State<CalculationExtraModalDialog> createState() =>
      _CalculationExtraModalDialogState();
}

class _CalculationExtraModalDialogState
    extends State<CalculationExtraModalDialog> {
  final List<CalculationDateModel> _dates = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPriceVal = TextEditingController();
  final TextEditingController _controllerPricePct = TextEditingController();

  bool _nameValid = false;
  bool _priceValid = false;

  String? _errorTextName;
  String? _errorTextPrice;
  CalculationDateModel? _date;

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    final DateFormat dateFormat = DateFormat('dd/MM/yy');

    for (int i = 0; i < widget.paymentsDates.length; i++) {
      final DateTime dateTime = widget.paymentsDates[i];

      _dates.add(
        CalculationDateModel(
          date: dateTime,
          name: dateFormat.format(dateTime),
        ),
      );
    }

    if (widget.calculationExtra != null) {
      final CalculationExtraModel extra = widget.calculationExtra!;

      _controllerName.text = extra.name;
      _validateName(extra.name);
      _controllerPriceVal.text = extra.priceVal;
      _validatePriceVal(extra.priceVal);
      _controllerPricePct.text = extra.pricePct;
      _validatePricePct(extra.pricePct);
      _onSelectDate(dateFormat.format(extra.date));
    }
  }

  void _validateName(String name) {
    setState(() => _nameValid = name.length > 1);
  }

  void _validatePriceVal(String depositVal) {
    final bool isValid = depositVal.length > 1;

    if (isValid) {
      final int deposit = parseString(depositVal);

      final double depositPct = (deposit * 100) / widget.price;

      _controllerPricePct.text = depositPct.toStringAsFixed(0);
    } else {
      _controllerPricePct.clear();
    }

    setState(() => _priceValid = isValid);
  }

  void _validatePricePct(String depositPct) {
    final bool isValid = depositPct.isNotEmpty;

    if (isValid) {
      final int deposit = parseString(depositPct);

      final double depositVal = (widget.price * deposit) / 100;

      _controllerPriceVal.text = depositVal.toStringAsFixed(0);
    } else {
      _controllerPriceVal.clear();
    }

    setState(() => _priceValid = isValid);
  }

  void _onSelectDate(String date) {
    final CalculationDateModel? calculationDate = _dates.firstWhereOrNull(
      (e) => e.name == date,
    );

    setState(() => _date = calculationDate);
  }

  void _createCalculationExtra() {
    _switchErrorName();
    _switchErrorPrice();

    final String name = _controllerName.text.trim();
    final String priceVal = _controllerPriceVal.text.trim();
    final String pricePct = _controllerPricePct.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Extra name is too short';

      return _switchErrorName(error: errorName);
    }

    if (priceVal.isEmpty || pricePct.isEmpty || !_priceValid) {
      const String errorPriceVal = 'Price is too short';

      return _switchErrorPrice(error: errorPriceVal);
    }

    if (_date == null) return;

    final String id = uuid();

    final CalculationExtraModel extra = CalculationExtraModel(
      id: id,
      name: name,
      priceVal: priceVal,
      pricePct: pricePct,
      date: _date!.date,
    );

    widget.onCreate(extra);
  }

  void _updateCalculationExtra() {
    _switchErrorName();
    _switchErrorPrice();

    final String name = _controllerName.text.trim();
    final String priceVal = _controllerPriceVal.text.trim();
    final String pricePct = _controllerPricePct.text.trim();

    if (name.isEmpty || !_nameValid) {
      const String errorName = 'Extra name is too short';

      return _switchErrorName(error: errorName);
    }

    if (priceVal.isEmpty || pricePct.isEmpty || !_priceValid) {
      const String errorPriceVal = 'Price is too short';

      return _switchErrorPrice(error: errorPriceVal);
    }

    if (_date == null) return;

    widget.onUpdate(
      widget.calculationExtra!.copyWith(
        name: name,
        priceVal: priceVal,
        pricePct: pricePct,
        date: _date!.date,
      ),
    );
  }

  void _switchErrorName({String? error}) {
    setState(() => _errorTextName = error);
  }

  void _switchErrorPrice({String? error}) {
    setState(() => _errorTextPrice = error);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 440.0,
          height: 348.0,
          margin: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 32.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.scaffoldSecondary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22.0,
                  vertical: 22.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BorderTextField(
                      controller: _controllerName,
                      labelText: 'Name',
                      hintText: 'Extra expense name',
                      errorText: _errorTextName,
                      maxLines: 2,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(64),
                      ],
                      onChanged: _validateName,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: BorderTextField(
                            controller: _controllerPriceVal,
                            labelText: 'Price in (${widget.currency})',
                            hintText: 'Enter value',
                            errorText: _errorTextPrice,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: _validatePriceVal,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: BorderTextField(
                            controller: _controllerPricePct,
                            labelText: 'Price in (%)',
                            hintText: 'Enter percent',
                            errorText: _errorTextPrice,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: _validatePricePct,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    AnimatedDropdown(
                      initialData: _date?.name,
                      labelText: 'Extra expense date',
                      hintText: 'Select date',
                      values: _dates.map((e) => e.name).toList(),
                      onChanged: _onSelectDate,
                    ),
                    const SizedBox(height: 22.0),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextButton(
                            text: 'Cancel',
                            onTap: widget.onCancel,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        if (widget.calculationExtra == null) ...[
                          Expanded(
                            child: CustomButton(
                              text: 'Create',
                              onTap: _createCalculationExtra,
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: CustomButton(
                              text: 'Save changes',
                              onTap: _updateCalculationExtra,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (widget.calculationExtra != null) ...[
                Positioned(
                  top: 16.0,
                  right: 16.0,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () => widget.onDelete(
                          widget.calculationExtra!,
                        ),
                        behavior: HitTestBehavior.opaque,
                        child: SvgPicture.asset(
                          AppIcons.delete,
                          width: 22.0,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
