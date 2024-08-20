import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/medias/media_response_model.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../resources/app_text_styles.dart';
import '../../../utils/constants.dart';
import '../../../widgets/loaders/cached_network_image_loader.dart';

class MediaViewerPageArguments {
  const MediaViewerPageArguments({
    required this.index,
    required this.media,
  });

  final int index;
  final List<MediaResponseModel> media;
}

class MediaViewerPage extends StatefulWidget {
  const MediaViewerPage({
    super.key,
    required this.index,
    required this.media,
    required this.navigateBack,
  });

  static const routePath = '/uncategorized_pages/media_viewer';

  final int index;
  final List<MediaResponseModel> media;
  final void Function() navigateBack;

  @override
  State<MediaViewerPage> createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends State<MediaViewerPage> {
  late final PageController _controller;

  int _index = 0;

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    _controller = PageController(
      initialPage: widget.index,
    );

    _switchIndex(widget.index);
  }

  void _scrollPrevious() {
    int index = _index;

    if (index == 0) {
      index = widget.media.length - 1;
    } else {
      index = _index - 1;
    }

    _controller.animateToPage(
      index,
      duration: kAnimationDuration,
      curve: kCurveAnimations,
    );

    _switchIndex(index);
  }

  void _scrollNext() {
    int index = _index;

    if (index == widget.media.length - 1) {
      index = 0;
    } else {
      index = _index + 1;
    }

    _controller.animateToPage(
      index,
      duration: kAnimationDuration,
      curve: kCurveAnimations,
    );

    _switchIndex(index);
  }

  void _switchIndex(int index) {
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Container(
            height: 32.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_index + 1}/${widget.media.length}',
                  style: AppTextStyles.paragraphSMedium.copyWith(
                    color: AppColors.scaffoldSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: widget.navigateBack,
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        AppIcons.close,
                        width: 24.0,
                        colorFilter: const ColorFilter.mode(
                          AppColors.scaffoldSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: _scrollPrevious,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 128.0,
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SvgPicture.asset(
                          AppIcons.arrowBack,
                          width: 24.0,
                          colorFilter: const ColorFilter.mode(
                            AppColors.scaffoldSecondary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.media.length,
                    itemBuilder: (_, int i) {
                      if (widget.media[i].dataUrl != null) {
                        return CachedNetworkImageLoader(
                          imageUrl: widget.media[i].dataUrl!,
                          fit: BoxFit.fitHeight,
                        );
                      }

                      return Image.memory(
                        widget.media[i].data!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fitHeight,
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: _scrollNext,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 128.0,
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        SvgPicture.asset(
                          AppIcons.arrowForward,
                          width: 24.0,
                          colorFilter: const ColorFilter.mode(
                            AppColors.scaffoldSecondary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}
