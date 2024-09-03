// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:x_overlay/src/channel/platform_interface.dart';

/// @nodoc
/// An implementation of [XOverlayPluginPlatform] that uses method channels.
class MethodChannelXOverlayPlugin extends XOverlayPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('x_overlay');

  /// backToDesktop
  @override
  Future<void> backToDesktop({
    bool nonRoot = false,
  }) async {
    if (Platform.isIOS) {
      debugPrint('not support in iOS');
      return;
    }

    debugPrint('nonRoot:$nonRoot');

    try {
      await methodChannel.invokeMethod<String>('backToDesktop', {
        'nonRoot': nonRoot,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to back to desktop: $e.');
    }
  }
}
