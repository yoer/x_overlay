// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:flutter/cupertino.dart';

/// page state of current page page
enum XOverlayPageState {
  idle,
  restored,
  overlaying,
}

typedef XOverlayPageStateNotifier = ValueNotifier<XOverlayPageState>;

/// overlay data, you can add custom variables with extends
/// ```dart
/// class MyOverlayData extends XOverlayData {
///   MyOverlayData({
///     required this.myVariable,
///   });
///
///   final String myVariable;
/// }
/// ```

class XOverlayData {}
