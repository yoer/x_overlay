// Package imports:
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Project imports:
import 'method_channel.dart';

/// @nodoc
abstract class XOverlayPluginPlatform extends PlatformInterface {
  /// Constructs a XOverlayPluginPlatform.
  XOverlayPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static XOverlayPluginPlatform _instance = MethodChannelXOverlayPlugin();

  /// The default instance of [XOverlayPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelUntitled].
  static XOverlayPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [XOverlayPluginPlatform] when
  /// they register themselves.
  static set instance(XOverlayPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// backToDesktop
  Future<void> backToDesktop({
    bool nonRoot = false,
  }) {
    throw UnimplementedError('backToDesktop has not been implemented.');
  }
}
