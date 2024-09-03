// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:x_overlay/src/channel/platform_interface.dart';

/// replace directly quit app with back to desktop when click back button of mobile, otherwise the page will be destroyed.
///
/// back to desktop when [canPop] is true
/// do nothing when [canPop] is false
class XOverlayPopScope extends StatefulWidget {
  const XOverlayPopScope({
    super.key,
    required this.child,
    this.canPop,
    this.onPopInvoked,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// When in the overlaying state, is it allowed back to the desktop or not.
  /// If true, it will back to the desktop; if false, nothing will happen.
  final bool Function()? canPop;

  /// If you don't want to back to the desktop directly, you can customize the pop logic
  final void Function()? onPopInvoked;

  @override
  XOverlayPopScopeState createState() => XOverlayPopScopeState();
}

class XOverlayPopScopeState extends State<XOverlayPopScope> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      /// Don't pop current widget directly when in overlaying
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        if (widget.canPop?.call() ?? true) {
          onPopInvoked();
        }

        /// not pop
        return;
      },
      child: widget.child,
    );
  }

  void onPopInvoked() {
    if (null == widget.onPopInvoked) {
      XOverlayPluginPlatform.instance.backToDesktop();
    } else {
      widget.onPopInvoked?.call();
    }
  }
}
