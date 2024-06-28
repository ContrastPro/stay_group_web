import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_text_styles.dart';

class BorderTextField extends StatefulWidget {
  const BorderTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.showErrorText = false,
    this.isObscureText = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.onSuffixTap,
    this.onChanged,
    this.focusListener,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool showErrorText;
  final bool isObscureText;
  final int maxLines;
  final String? prefixIcon;
  final String? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onSuffixTap;
  final void Function(String)? onChanged;
  final void Function(bool)? focusListener;

  @override
  State<BorderTextField> createState() => _BorderTextFieldState();
}

class _BorderTextFieldState extends State<BorderTextField> {
  final FocusNode _focusNode = FocusNode();

  bool _hasFocus = false;

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  @override
  void dispose() {
    _setDisposeData();
    super.dispose();
  }

  void _setInitialData() {
    _focusNode.addListener(_focusNodeListener);
  }

  void _setDisposeData() {
    _focusNode.removeListener(_focusNodeListener);

    _focusNode.dispose();
  }

  void _focusNodeListener() {
    if (_focusNode.hasFocus) {
      setState(() => _hasFocus = true);
    } else {
      setState(() => _hasFocus = false);
    }

    if (widget.focusListener != null) {
      widget.focusListener!(_focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTextStyles.paragraphSMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 4.0),
        ],
        Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: AppColors.scaffoldSecondary,
            border: widget.errorText == null
                ? Border.all(
                    color: !_hasFocus
                        ? AppColors.border
                        : AppColors.secondary.withOpacity(0.20),
                  )
                : Border.all(
                    color: AppColors.error.withOpacity(0.30),
                  ),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: AppColors.regularShadow,
          ),
          child: Row(
            children: [
              const SizedBox(width: 12.0),
              if (widget.prefixIcon != null) ...[
                SvgPicture.asset(
                  widget.prefixIcon!,
                  width: 22.0,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8.0),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  minLines: 1,
                  maxLines: widget.maxLines,
                  cursorHeight: 16.0,
                  style: AppTextStyles.paragraphMRegular,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTextStyles.paragraphMRegular.copyWith(
                      color: AppColors.iconPrimary,
                    ),
                    contentPadding: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    border: InputBorder.none,
                  ),
                  obscureText: widget.isObscureText,
                  inputFormatters: widget.inputFormatters,
                  onChanged: widget.onChanged,
                ),
              ),
              if (widget.suffixIcon != null) ...[
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: widget.onSuffixTap,
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(
                    widget.suffixIcon!,
                    width: 22.0,
                    colorFilter: const ColorFilter.mode(
                      AppColors.iconPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
              ] else ...[
                const SizedBox(width: 12.0),
              ],
            ],
          ),
        ),
        if (widget.errorText != null && widget.showErrorText) ...[
          const SizedBox(height: 5.0),
          Text(
            widget.errorText!,
            style: AppTextStyles.paragraphSRegular.copyWith(
              color: AppColors.error,
            ),
          ),
        ]
      ],
    );
  }
}
