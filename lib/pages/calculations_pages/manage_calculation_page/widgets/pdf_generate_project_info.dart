import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';

import '../../../../models/companies/company_model.dart';
import '../../../../models/projects/project_model.dart';
import '../../../../resources/app_images.dart';
import '../blocs/manage_calculation_bloc/manage_calculation_bloc.dart';
import 'pdf_generate_document.dart';

Future<pdf.Page> pdfGenerateProjectInfo({
  required PdfPageFormat format,
  required ManageCalculationState state,
  CompanyModel? company,
  ProjectModel? project,
  required String section,
  required String floor,
  required String number,
  required String type,
  required String rooms,
  required String bathrooms,
  required String total,
  required String living,
  required pdf.TextStyle stylePrimary,
  required pdf.TextStyle styleSecondary,
}) async {
  final List<pdf.ImageProvider> projectImages = [];

  if (project != null) {
    if (project.info.media != null) {
      for (int i = 0; i < project.info.media!.length; i++) {
        final pdf.ImageProvider image = await networkImage(
          project.info.media![i].thumbnail,
        );

        projectImages.add(image);
      }
    }
  }

  final pdf.ImageProvider imageLocation = await imageFromAssetBundle(
    AppImages.location,
  );

  return pdf.Page(
    pageFormat: format,
    margin: const pdf.EdgeInsets.symmetric(
      horizontal: 42.0,
      vertical: 72.0,
    ),
    build: (pdf.Context context) {
      return pdf.Column(
        children: [
          _pdfGetProjectHeader(
            state: state,
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
          _pdfGetProjectContent(
            project: project,
            projectImages: projectImages,
            imageLocation: imageLocation,
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
          ),
          _pdfGetProjectFooter(
            company: company,
            stylePrimary: stylePrimary,
            styleSecondary: styleSecondary,
          ),
        ],
      );
    },
  );
}

pdf.Container _pdfGetProjectHeader({
  required ManageCalculationState state,
  required pdf.TextStyle stylePrimary,
  required pdf.TextStyle styleSecondary,
}) {
  return pdf.Container(
    width: double.infinity,
    height: 72.0,
    padding: const pdf.EdgeInsets.symmetric(
      horizontal: 22.0,
    ),
    color: pdfIconPrimary,
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
                    color: pdfScaffoldSecondary,
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
                    color: pdfScaffoldSecondary,
                  ),
                  maxLines: 2,
                ),
                pdf.Text(
                  state.userData!.info.phone ??
                      state.userData!.credential.email,
                  style: styleSecondary.copyWith(
                    color: pdfScaffoldSecondary,
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
                  color: pdfScaffoldSecondary,
                ),
                maxLines: 2,
              ),
              pdf.Text(
                state.userData!.credential.email,
                style: styleSecondary.copyWith(
                  color: pdfScaffoldSecondary,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

pdf.Expanded _pdfGetProjectContent({
  ProjectModel? project,
  required List<pdf.ImageProvider> projectImages,
  required pdf.ImageProvider imageLocation,
  required String section,
  required String floor,
  required String number,
  required String type,
  required String rooms,
  required String bathrooms,
  required String total,
  required String living,
  required pdf.TextStyle stylePrimary,
  required pdf.TextStyle styleSecondary,
}) {
  return pdf.Expanded(
    child: pdf.Column(
      crossAxisAlignment: pdf.CrossAxisAlignment.start,
      children: [
        if (project != null) ...[
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
            project.info.name,
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
                project.info.location,
                style: styleSecondary,
                maxLines: 1,
              ),
            ],
          ),
          pdf.SizedBox(height: 10.0),
          pdf.Text(
            project.info.description,
            style: styleSecondary,
            maxLines: 8,
          ),
          pdf.SizedBox(height: 18.0),
          pdf.Expanded(
            child: pdf.GridView(
              crossAxisCount: 4,
              children: [
                if (section.isNotEmpty) ...[
                  _pdfGetProjectFeatureItem(
                    title: 'Section',
                    data: section,
                    stylePrimary: stylePrimary,
                    styleSecondary: styleSecondary,
                  ),
                ],
                if (floor.isNotEmpty) ...[
                  _pdfGetProjectFeatureItem(
                    title: 'Floor',
                    data: floor,
                    stylePrimary: stylePrimary,
                    styleSecondary: styleSecondary,
                  ),
                ],
                if (number.isNotEmpty) ...[
                  _pdfGetProjectFeatureItem(
                    title: 'Unit number',
                    data: number,
                    stylePrimary: stylePrimary,
                    styleSecondary: styleSecondary,
                  ),
                ],
                if (type.isNotEmpty) ...[
                  _pdfGetProjectFeatureItem(
                    title: 'Unit type',
                    data: type,
                    stylePrimary: stylePrimary,
                    styleSecondary: styleSecondary,
                  ),
                ],
                if (rooms.isNotEmpty) ...[
                  _pdfGetProjectFeatureItem(
                    title: 'Rooms',
                    data: rooms,
                    stylePrimary: stylePrimary,
                    styleSecondary: styleSecondary,
                  ),
                ],
                if (bathrooms.isNotEmpty) ...[
                  _pdfGetProjectFeatureItem(
                    title: 'Bathrooms',
                    data: bathrooms,
                    stylePrimary: stylePrimary,
                    styleSecondary: styleSecondary,
                  ),
                ],
                if (total.isNotEmpty) ...[
                  _pdfGetProjectFeatureItem(
                    title: 'Total area',
                    data: '$total m2',
                    stylePrimary: stylePrimary,
                    styleSecondary: styleSecondary,
                  ),
                ],
                if (living.isNotEmpty) ...[
                  _pdfGetProjectFeatureItem(
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
      ],
    ),
  );
}

pdf.Padding _pdfGetProjectFeatureItem({
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

pdf.Container _pdfGetProjectFooter({
  CompanyModel? company,
  required pdf.TextStyle stylePrimary,
  required pdf.TextStyle styleSecondary,
}) {
  return pdf.Container(
    width: double.infinity,
    height: 72.0,
    padding: const pdf.EdgeInsets.symmetric(
      horizontal: 22.0,
    ),
    color: pdfIconPrimary,
    child: pdf.Column(
      mainAxisAlignment: pdf.MainAxisAlignment.center,
      crossAxisAlignment: pdf.CrossAxisAlignment.start,
      children: [
        if (company != null) ...[
          pdf.Text(
            'About company',
            style: stylePrimary.copyWith(
              fontSize: 10.0,
              color: pdfScaffoldSecondary,
            ),
          ),
          pdf.SizedBox(height: 1.5),
          pdf.Text(
            '${company.info.name}. ${company.info.description}',
            style: styleSecondary.copyWith(
              fontSize: 8.0,
              color: pdfScaffoldSecondary,
            ),
            maxLines: 3,
          ),
        ] else ...[
          pdf.Text(
            'www.staygroup.space',
            style: stylePrimary.copyWith(
              fontSize: 10.0,
              color: pdfScaffoldSecondary,
            ),
          ),
        ],
      ],
    ),
  );
}
