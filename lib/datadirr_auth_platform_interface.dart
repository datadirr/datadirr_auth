import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'datadirr_auth_method_channel.dart';

abstract class DatadirrAuthPlatform extends PlatformInterface {
  /// Constructs a DatadirrAuthPlatform.
  DatadirrAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static DatadirrAuthPlatform _instance = MethodChannelDatadirrAuth();

  /// The default instance of [DatadirrAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelDatadirrAuth].
  static DatadirrAuthPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DatadirrAuthPlatform] when
  /// they register themselves.
  static set instance(DatadirrAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
