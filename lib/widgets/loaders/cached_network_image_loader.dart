import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageLoader extends StatelessWidget {
  const CachedNetworkImageLoader({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: fit,
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
}
