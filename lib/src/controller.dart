// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:x_overlay/src/core/overlay_machine.dart';
import 'package:x_overlay/src/defines.dart';

part 'package:x_overlay/src/core/controller.p.dart';

/// Here are the APIs related to overlay.
class XOverlayController with XOverlayControllerPrivate {
  /// current data
  XOverlayData? get data => private.data;

  /// current page state notifier
  ValueNotifier<XOverlayPageState> get pageStateNotifier =>
      private.pageStateNotifier;

  /// state machine
  XOverlayPageMachine get pageMachine => private.pageMachine;

  /// restore the content widget from overlay
  bool restore(
    BuildContext context, {
    bool rootNavigator = true,
    bool withSafeArea = true,
  }) {
    if (XOverlayPageState.overlaying != private.pageStateNotifier.value) {
      debugPrint('restore, is not overlaying, ignore');

      return false;
    }

    if (null == private.data) {
      debugPrint('restore, data is null');

      return false;
    }

    debugPrint('restore, '
        'context:$context, '
        'rootNavigator:$rootNavigator, '
        'withSafeArea:$withSafeArea, ');

    try {
      final overlayData = private.data!;
      Navigator.of(context, rootNavigator: rootNavigator).push(
        MaterialPageRoute(builder: (context) {
          final roomWidget =
              private.restoreWidgetQuery?.call(overlayData) ?? Container();
          return withSafeArea ? SafeArea(child: roomWidget) : roomWidget;
        }),
      );
    } catch (e) {
      debugPrint('restore, navigator push to content page exception:$e');

      return false;
    }

    /// re-enter room page
    private.pageMachine.changeState(
      XOverlayPageState.restored,
    );
    private.onIdle();

    return true;
  }

  /// switch the content widget to overlay
  bool overlay(
    BuildContext context, {
    required XOverlayData data,
    bool rootNavigator = true,
  }) {
    if (XOverlayPageState.overlaying == private.pageMachine.state()) {
      debugPrint('current is overlaying, ignore');

      return false;
    }

    debugPrint('context:$context, rootNavigator:$rootNavigator, ');

    try {
      /// pop current room page
      Navigator.of(
        context,
        rootNavigator: rootNavigator,
      ).pop();
    } catch (e) {
      debugPrint('navigator pop exception:$e');

      return false;
    }

    private.onOverlaying(data: data);
    private.pageMachine.changeState(
      XOverlayPageState.overlaying,
    );

    return true;
  }

  /// update data when in overlaying state
  void updateData(XOverlayData overlayData) {
    debugPrint('update data');

    private.data = overlayData;
  }

  /// if the content widget close in overlaying state,
  /// just hide the overlay widget.
  void hide() {
    debugPrint('hide');

    private.pageMachine.changeState(
      XOverlayPageState.idle,
    );
    private.onIdle();
  }
}
