import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';

import '../../../../models/calculations/calculation_extra_model.dart';
import '../../../../models/calculations/calculation_period_model.dart';
import '../../../../models/companies/company_model.dart';
import '../../../../models/projects/project_model.dart';
import '../blocs/manage_calculation_bloc/manage_calculation_bloc.dart';
import 'pdf_generate_calculation_info.dart';
import 'pdf_generate_project_info.dart';

const PdfColor pdfScaffoldSecondary = PdfColor.fromInt(0xFFFCFEFF);
const PdfColor pdfTextPrimary = PdfColor.fromInt(0xFF141C25);
const PdfColor pdfTextSecondary = PdfColor.fromInt(0xFF344051);
const PdfColor pdfIconPrimary = PdfColor.fromInt(0xFF637083);

Future<Uint8List> pdfGenerateDocument({
  required PdfPageFormat format,
  required ManageCalculationState state,
  required CompanyModel? company,
  required ProjectModel? project,
  required String section,
  required String floor,
  required String number,
  required String type,
  required String rooms,
  required String bathrooms,
  required String total,
  required String living,
  required bool calculationValid,
  required String? currency,
  required String depositVal,
  required String depositPct,
  required CalculationPeriodModel? period,
  required DateTime? startInstallments,
  required DateTime? endInstallments,
  required List<CalculationExtraModel> extra,
  required int? Function() getPrice,
  required int? Function() getRemainingPrice,
  required int? Function() getPaymentsCount,
  required int? Function() getPayment,
  required List<DateTime>? Function() getPaymentsDates,
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
    color: pdfTextPrimary,
  );

  final pdf.TextStyle styleSecondary = pdf.TextStyle(
    font: fontRegular,
    fontSize: 10.0,
    color: pdfTextSecondary,
  );

  final pdf.Page projectInfo = await pdfGenerateProjectInfo(
    format: format,
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
    stylePrimary: stylePrimary,
    styleSecondary: styleSecondary,
  );

  document.addPage(projectInfo);

  if (calculationValid) {
    final int? price = getPrice();
    final int? remainingPrice = getRemainingPrice();
    final int? paymentsCount = getPaymentsCount();
    final int? payment = getPayment();
    final List<DateTime>? paymentsDates = getPaymentsDates();

    final pdf.MultiPage calculationInfo = await pdfGenerateCalculationInfo(
      format: format,
      project: project,
      currency: currency!,
      price: price!,
      depositVal: depositVal,
      depositPct: depositPct,
      period: period!,
      startInstallments: startInstallments!,
      endInstallments: endInstallments!,
      extra: extra,
      remainingPrice: remainingPrice!,
      paymentsCount: paymentsCount!,
      payment: payment!,
      paymentsDates: paymentsDates!,
      stylePrimary: stylePrimary,
      styleSecondary: styleSecondary,
    );

    document.addPage(calculationInfo);
  }

  final Uint8List savedDocument = await document.save();

  return savedDocument;
}
