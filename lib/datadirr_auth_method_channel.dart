import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'datadirr_auth_platform_interface.dart';

/// An implementation of [DatadirrAuthPlatform] that uses method channels.
class MethodChannelDatadirrAuth extends DatadirrAuthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('datadirr_auth');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
