import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

import '../../../../models/calculations/calculation_extra_model.dart';
import '../../../../models/calculations/calculation_period_model.dart';
import '../../../../models/projects/project_model.dart';
import '../../../../utils/helpers.dart';
import 'pdf_generate_document.dart';

Future<pdf.MultiPage> pdfGenerateCalculationInfo({
  required PdfPageFormat format,
  required ProjectModel? project,
  required String currency,
  required int price,
  required String depositVal,
  required String depositPct,
  required CalculationPeriodModel period,
  required DateTime startInstallments,
  required DateTime endInstallments,
  required List<CalculationExtraModel> extra,
  required int remainingPrice,
  required int paymentsCount,
  required int payment,
  required List<DateTime> paymentsDates,
  required pdf.TextStyle stylePrimary,
  required pdf.TextStyle styleSecondary,
}) async {
  final DateFormat dateFormat = DateFormat.yMMMMd();
  final String start = dateFormat.format(startInstallments);
  final String end = dateFormat.format(endInstallments);

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
              ? 'Calculations for "${project.info.name}"'
              : 'Calculations',
          style: stylePrimary.copyWith(
            fontSize: 14.0,
          ),
          maxLines: 1,
        ),
        pdf.SizedBox(height: 6.0),
        _pdfGetCalculationInfoItem(
          title: 'Unit price (without extra costs)',
          data: '$currency$price',
          stylePrimary: stylePrimary,
          styleSecondary: styleSecondary,
        ),
        if (depositVal.isNotEmpty) ...[
          _pdfGetCalculationInfoItem(
            title: 'First deposit',
            data: '$currency$depositVal — $depositPct%',
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
        ],
        if (payment > 0) ...[
          _pdfGetCalculationInfoItem(
            title: 'Installment plan',
            data:
                '${period.name}(~$currency$payment) — $paymentsCount payment(s)',
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
          _pdfGetCalculationInfoItem(
            title: 'Installment terms',
            data: '$start — $end',
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
          pdf.SizedBox(height: 14.0),
          _pdfGetCalculationItem(
            addColor: true,
            number: '№',
            date: 'Payment date',
            total: 'Total',
            payment: 'Installments',
            extraPrice: 'Taxes and fees',
            extraDescription: 'Description',
            styleSecondary: styleSecondary,
          ),
          ...calculations,
        ],
      ];
    },
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
    final DateFormat dateFormat = DateFormat('dd/MM/yy');

    for (int i = 0; i < paymentsCount; i++) {
      int extraPrice = 0;

      final CalculationExtraModel? calculationExtra = extra.firstWhereOrNull(
        (e) => e.date.isAtSameMomentAs(paymentsDates[i]),
      );

      if (calculationExtra != null) {
        extraPrice = parseString(calculationExtra.priceVal);
      }

      calculations.add(
        _pdfGetCalculationItem(
          number: '${i + 1}',
          date: dateFormat.format(paymentsDates[i]),
          total: '$currency${payment + extraPrice}',
          payment: '$currency$payment',
          extraPrice: '$currency$extraPrice',
          extraDescription: calculationExtra?.name,
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
  String? extraDescription,
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
        pdf.Container(
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
          child: pdf.Container(
            child: pdf.Text(
              date,
              style: styleSecondary.copyWith(
                fontSize: 8.0,
                color: addColor ? pdfScaffoldSecondary : null,
              ),
              textAlign: pdf.TextAlign.center,
            ),
          ),
        ),
        pdf.Expanded(
          flex: 15,
          child: pdf.Container(
            child: pdf.Text(
              total,
              style: styleSecondary.copyWith(
                fontSize: 8.0,
                color: addColor ? pdfScaffoldSecondary : null,
              ),
              textAlign: pdf.TextAlign.center,
            ),
          ),
        ),
        pdf.Expanded(
          flex: 15,
          child: pdf.Container(
            child: pdf.Text(
              payment,
              style: styleSecondary.copyWith(
                fontSize: 8.0,
                color: addColor ? pdfScaffoldSecondary : null,
              ),
              textAlign: pdf.TextAlign.center,
            ),
          ),
        ),
        pdf.Expanded(
          flex: 20,
          child: pdf.Container(
            child: pdf.Text(
              extraPrice,
              style: styleSecondary.copyWith(
                fontSize: 8.0,
                color: addColor ? pdfScaffoldSecondary : null,
              ),
              textAlign: pdf.TextAlign.center,
            ),
          ),
        ),
        pdf.Expanded(
          flex: 35,
          child: pdf.Container(
            child: pdf.Text(
              extraDescription ?? '',
              style: styleSecondary.copyWith(
                fontSize: addColor ? 8.0 : 6.0,
                color: addColor ? pdfScaffoldSecondary : null,
              ),
            ),
          ),
        ),
        pdf.SizedBox(width: 16.0),
        pdf.Column(
          mainAxisAlignment: pdf.MainAxisAlignment.center,
          crossAxisAlignment: pdf.CrossAxisAlignment.end,
          children: [
            pdf.Container(
              width: 8.0,
              height: 8.0,
              margin: const pdf.EdgeInsets.symmetric(
                vertical: 6.0,
              ),
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
