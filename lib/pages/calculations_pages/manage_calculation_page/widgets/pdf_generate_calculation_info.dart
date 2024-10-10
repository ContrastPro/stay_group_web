import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

import '../../../../models/calculations/calculation_extra_model.dart';
import '../../../../models/calculations/calculation_period_model.dart';
import '../../../../models/projects/project_model.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helpers.dart';
import '../../../../utils/translate_locale.dart';
import 'pdf_generate_document.dart';

const TranslateLocale _locale = TranslateLocale(
  'calculations.manage_calculation',
);

Future<pdf.MultiPage> pdfGenerateCalculationInfo({
  required PdfPageFormat format,
  ProjectModel? project,
  required String currency,
  required int price,
  required String depositVal,
  required String depositPct,
  required CalculationPeriodModel period,
  required DateTime startInstallments,
  required DateTime endInstallments,
  required List<CalculationExtraModel> extra,
  required int paymentsCount,
  required int payment,
  required List<DateTime> paymentsDates,
  required pdf.TextStyle stylePrimary,
  required pdf.TextStyle styleSecondary,
}) async {
  final DateFormat dateFormat = DateFormat.yMMMMd();
  final String start = dateFormat.format(startInstallments);
  final String end = dateFormat.format(endInstallments);

  int totalPrice = price;

  for (int i = 0; i < extra.length; i++) {
    totalPrice = totalPrice + parseStringInt(extra[i].priceVal);
  }

  final List<pdf.Widget> calculations = _pdfGetCalculations(
    currency: currency,
    extra: extra,
    paymentsCount: paymentsCount,
    payment: payment,
    paymentsDates: paymentsDates,
    styleSecondary: styleSecondary,
  );

  return pdf.MultiPage(
    pageFormat: format,
    margin: const pdf.EdgeInsets.symmetric(
      horizontal: 42.0,
      vertical: 72.0,
    ),
    build: (pdf.Context context) {
      return [
        pdf.Text(
          project != null
              ? _locale.tr('calculations_for', args: [
                  project.info.name,
                ])
              : _locale.tr('calculations'),
          style: stylePrimary.copyWith(
            fontSize: 14.0,
          ),
          maxLines: 1,
        ),
        pdf.SizedBox(height: 6.0),
        _pdfGetCalculationInfoItem(
          title: _locale.tr('unit_price'),
          data: '$currency$price',
          stylePrimary: stylePrimary,
          styleSecondary: styleSecondary,
        ),
        if (depositVal.isNotEmpty) ...[
          _pdfGetCalculationInfoItem(
            title: _locale.tr('first_deposit'),
            data: '$currency$depositVal — $depositPct%',
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
        ],
        if (payment > 0) ...[
          _pdfGetCalculationInfoItem(
            title: _locale.tr('installment_plan'),
            data: _locale.tr('payments', args: [
              '${period.name}(~$currency$payment) — $paymentsCount',
            ]),
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
          _pdfGetCalculationInfoItem(
            title: _locale.tr('installment_terms'),
            data: '$start — $end',
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
          if (price != totalPrice) ...[
            _pdfGetCalculationInfoItem(
              title: _locale.tr('total_price'),
              data: '$currency$totalPrice',
              stylePrimary: stylePrimary,
              styleSecondary: styleSecondary,
            ),
          ],
          pdf.SizedBox(height: 12.0),
          _pdfGetCalculationItem(
            addColor: true,
            number: '№',
            date: _locale.tr('payment_date'),
            total: _locale.tr('total'),
            payment: _locale.tr('installments'),
            extraPrice: _locale.tr('taxes_fees'),
            extraDescription: _locale.tr('description'),
            styleSecondary: styleSecondary,
          ),
          ...calculations,
        ],
      ];
    },
  );
}

List<pdf.Widget> _pdfGetCalculations({
  required String currency,
  required List<CalculationExtraModel> extra,
  required int paymentsCount,
  required int payment,
  required List<DateTime> paymentsDates,
  required pdf.TextStyle styleSecondary,
}) {
  final List<pdf.Widget> calculations = [];

  if (payment > 0) {
    final DateFormat dateFormat = DateFormat(kDatePattern);

    for (int i = 0; i < paymentsCount; i++) {
      final DateTime paymentDate = paymentsDates[i];

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
        _pdfGetCalculationItem(
          number: '${i + 1}',
          date: dateFormat.format(paymentDate),
          total: '$currency${payment + extraPrice}',
          payment: '$currency$payment',
          extraPrice: '$currency$extraPrice',
          extraDescription: extraDescription,
          styleSecondary: styleSecondary,
        ),
      );
    }
  }

  return calculations;
}

pdf.Container _pdfGetCalculationItem({
  bool addColor = false,
  required String number,
  required String date,
  required String total,
  required String payment,
  required String extraPrice,
  required String extraDescription,
  required pdf.TextStyle styleSecondary,
}) {
  return pdf.Container(
    height: 20.0,
    decoration: pdf.BoxDecoration(
      color: addColor ? pdfIconPrimary : null,
      border: !addColor
          ? const pdf.Border(
              bottom: pdf.BorderSide(
                color: pdfIconPrimary,
                width: 0.6,
              ),
            )
          : null,
    ),
    child: pdf.Row(
      children: [
        pdf.SizedBox(
          width: 20.0,
          child: pdf.Text(
            number,
            style: styleSecondary.copyWith(
              fontSize: 8.0,
              color: addColor ? pdfScaffoldSecondary : null,
            ),
            textAlign: pdf.TextAlign.center,
          ),
        ),
        pdf.Expanded(
          flex: 15,
          child: pdf.Text(
            date,
            style: styleSecondary.copyWith(
              fontSize: 8.0,
              color: addColor ? pdfScaffoldSecondary : null,
            ),
            textAlign: pdf.TextAlign.center,
          ),
        ),
        pdf.Expanded(
          flex: 15,
          child: pdf.Text(
            total,
            style: styleSecondary.copyWith(
              fontSize: 8.0,
              color: addColor ? pdfScaffoldSecondary : null,
            ),
            textAlign: pdf.TextAlign.center,
          ),
        ),
        pdf.Expanded(
          flex: 15,
          child: pdf.Text(
            payment,
            style: styleSecondary.copyWith(
              fontSize: 8.0,
              color: addColor ? pdfScaffoldSecondary : null,
            ),
            textAlign: pdf.TextAlign.center,
          ),
        ),
        pdf.Expanded(
          flex: 20,
          child: pdf.Text(
            extraPrice,
            style: styleSecondary.copyWith(
              fontSize: 8.0,
              color: addColor ? pdfScaffoldSecondary : null,
            ),
            textAlign: pdf.TextAlign.center,
          ),
        ),
        pdf.Expanded(
          flex: 35,
          child: pdf.Text(
            extraDescription.isNotEmpty ? extraDescription : '—',
            style: styleSecondary.copyWith(
              fontSize: addColor ? 8.0 : 6.0,
              color: addColor ? pdfScaffoldSecondary : null,
            ),
            maxLines: 2,
          ),
        ),
        pdf.SizedBox(width: 6.0),
        pdf.Column(
          mainAxisAlignment: pdf.MainAxisAlignment.center,
          crossAxisAlignment: pdf.CrossAxisAlignment.end,
          children: [
            pdf.Container(
              width: 8.0,
              height: 8.0,
              decoration: pdf.BoxDecoration(
                border: pdf.Border.all(
                  color: pdfIconPrimary,
                  width: 0.6,
                ),
              ),
            ),
          ],
        ),
        pdf.SizedBox(width: 6.0),
      ],
    ),
  );
}

pdf.Padding _pdfGetCalculationInfoItem({
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
