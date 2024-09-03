part of 'package:x_overlay/src/controller.dart';

/// @nodoc
mixin XOverlayControllerPrivate {
  final _private = XOverlayControllerPrivateImpl();

  /// Don't call that
  XOverlayControllerPrivateImpl get private => _private;
}

/// @nodoc
class XOverlayControllerPrivateImpl {
  Widget Function(XOverlayData overlayData)? restoreWidgetQuery;

  final pageStateNotifier = ValueNotifier<XOverlayPageState>(
    XOverlayPageState.idle,
  );

  XOverlayData? data;

  final pageMachine = XOverlayPageMachine();

  void updateRestoreWidgetQuery({
    required Widget Function(
      XOverlayData overlayData,
    ) restoreWidgetQuery,
  }) {
    this.restoreWidgetQuery = restoreWidgetQuery;
  }

  void onOverlaying({
    required XOverlayData data,
  }) {
    debugPrint('onOverlaying');

    this.data = data;

    pageStateNotifier.value = XOverlayPageState.overlaying;

    pageMachine.listenStateChanged(onOverlayPageStateChanged);
  }

  void onIdle() {
    debugPrint('onIdle');

    pageStateNotifier.value = XOverlayPageState.idle;

    data = null;

    pageMachine.removeListenStateChanged(onOverlayPageStateChanged);
  }

  void onOverlayPageStateChanged(XOverlayPageState state) {
    pageStateNotifier.value = state;
  }
}
