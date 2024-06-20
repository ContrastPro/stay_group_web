import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.action,
    this.onAction,
    this.onLeading,
  });

  final Widget? leading;
  final String? title;
  final Widget? action;
  final void Function()? onAction;
  final void Function()? onLeading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      leading: leading != null
          ? GestureDetector(
              onTap: onLeading,
              behavior: HitTestBehavior.opaque,
              child: Stack(
                alignment: Alignment.center,
                children: [leading!],
              ),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      actions: [
        if (action != null) ...[
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [action!],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
