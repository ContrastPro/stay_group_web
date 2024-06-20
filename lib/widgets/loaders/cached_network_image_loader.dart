import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../resources/app_images.dart';

class CachedNetworkImageLoader extends StatelessWidget {
  const CachedNetworkImageLoader({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (_, __, progress) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress.progress,
                strokeWidth: 3.0,
              ),
            ],
          );
        },
      );
    }

    return Image.asset(
      AppImages.avatarPlaceholder,
      fit: BoxFit.cover,
    );
  }
}
