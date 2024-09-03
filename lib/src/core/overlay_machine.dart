// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:statemachine/statemachine.dart' as sm;

// Project imports:
import 'package:x_overlay/src/defines.dart';

/// @nodoc
typedef XOverlayPageStateChanged = void Function(
  XOverlayPageState,
);

class XOverlayPageMachine {
  XOverlayPageMachine() {
    _machine.onAfterTransition.listen((event) {
      debugPrint('machine overlay, from ${event.source} to ${event.target}');

      for (final listener in _onStateChangedListeners) {
        listener.call(_machine.current!.identifier);
      }
    });

    _stateIdle =
        _machine.newState(XOverlayPageState.idle); //  default state;
    _stateCalling = _machine.newState(XOverlayPageState.restored);
    _stateOverlaying = _machine.newState(XOverlayPageState.overlaying);
  }

  sm.Machine<XOverlayPageState> get machine => _machine;

  XOverlayPageState state() {
    return _machine.current?.identifier ?? XOverlayPageState.idle;
  }

  /// Whether the current live audio room widget is in a overlaying state.
  bool get isOverlaying => XOverlayPageState.overlaying == state();

  void listenStateChanged(XOverlayPageStateChanged listener) {
    _onStateChangedListeners.add(listener);
  }

  void removeListenStateChanged(XOverlayPageStateChanged listener) {
    _onStateChangedListeners.remove(listener);
  }

  void changeState(XOverlayPageState state) {
    debugPrint('change state outside to $state');

    switch (state) {
      case XOverlayPageState.idle:
        _stateIdle.enter();
        break;
      case XOverlayPageState.restored:
        _stateCalling.enter();
        break;
      case XOverlayPageState.overlaying:
        _stateOverlaying.enter();
        break;
    }
  }

  final _machine = sm.Machine<XOverlayPageState>();
  final List<XOverlayPageStateChanged> _onStateChangedListeners = [];

  late sm.State<XOverlayPageState> _stateIdle;
  late sm.State<XOverlayPageState> _stateCalling;
  late sm.State<XOverlayPageState> _stateOverlaying;
}
