// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:x_overlay/src/controller.dart';
import 'package:x_overlay/src/defines.dart';

class XOverlayButton extends StatefulWidget {
  const XOverlayButton({
    super.key,
    required this.controller,
    required this.dataQuery,
    this.onWillPressed,
    this.icon,
    this.backgroundColor,
    this.iconSize,
    this.buttonSize,
    this.rootNavigator = false,
  });

  final XOverlayController controller;

  /// Data needed to return to the overlay page
  final XOverlayData Function() dataQuery;

  final bool rootNavigator;

  /// The icon widget, which can be any widget.
  final Widget? icon;

  /// The background color of the icon.
  final Color? backgroundColor;

  ///  You can do what you want
  final VoidCallback? onWillPressed;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  @override
  State<XOverlayButton> createState() => _XOverlayButtonState();
}

/// @nodoc
class _XOverlayButtonState extends State<XOverlayButton> {
  @override
  Widget build(BuildContext context) {
    final containerSize = widget.buttonSize ?? const Size(96, 96);
    final sizeBoxSize = widget.iconSize ?? const Size(56, 56);

    return GestureDetector(
      onTap: () {
        if (widget.onWillPressed != null) {
          widget.onWillPressed!();
        }

        if (!widget.controller.overlay(
          context,
          data: widget.dataQuery(),
          rootNavigator: widget.rootNavigator,
        )) {
          return;
        }
      },
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child: widget.icon ??
              const Icon(
                Icons.minimize,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
