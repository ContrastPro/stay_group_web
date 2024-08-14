import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/medias/media_response_model.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_icons.dart';
import '../../resources/app_text_styles.dart';
import '../../services/in_app_notification_service.dart';
import '../../services/media_service.dart';
import '../../utils/constants.dart';

class MediaOrganizer extends StatelessWidget {
  const MediaOrganizer({
    super.key,
    required this.labelText,
    this.maxLength = 5,
    required this.media,
    required this.onPickMedia,
    required this.onDeleteMedia,
  });

  final String labelText;
  final int maxLength;
  final List<MediaResponseModel> media;
  final void Function(MediaResponseModel) onPickMedia;
  final void Function(MediaResponseModel) onDeleteMedia;

  static const MediaService _mediaService = MediaService.instance;

  Future<void> _pickGallery() async {
    final MediaResponseModel? response = await _mediaService.pickGallery();

    if (response == null) return;

    if (!kImageFormats.contains(response.format)) {
      return InAppNotificationService.show(
        title: 'Wrong file format',
        type: InAppNotificationType.error,
      );
    }

    if (response.data!.lengthInBytes > kFileWeightMax) {
      return InAppNotificationService.show(
        title: 'File too large',
        type: InAppNotificationType.error,
      );
    }

    onPickMedia(response);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: AppTextStyles.paragraphSMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 4.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: media.length + 1,
          itemBuilder: (_, int i) {
            if (i < media.length) {
              return Container(
                width: double.infinity,
                height: 40.0,
                margin: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldSecondary,
                  border: Border.all(
                    color: AppColors.border,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: AppColors.regularShadow,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        media[i].name,
                        style: AppTextStyles.paragraphMRegular,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () => onDeleteMedia(
                        media[i],
                      ),
                      behavior: HitTestBehavior.opaque,
                      child: SvgPicture.asset(
                        AppIcons.delete,
                        width: 22.0,
                        colorFilter: const ColorFilter.mode(
                          AppColors.iconPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                  ],
                ),
              );
            }

            if (maxLength > media.length) {
              return GestureDetector(
                onTap: _pickGallery,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  height: 40.0,
                  margin: const EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldSecondary,
                    border: Border.all(
                      color: AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: AppColors.regularShadow,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12.0),
                      SvgPicture.asset(
                        AppIcons.upload,
                        width: 22.0,
                        colorFilter: const ColorFilter.mode(
                          AppColors.iconPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Click to choose file',
                        style: AppTextStyles.paragraphMRegular.copyWith(
                          color: AppColors.iconPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
