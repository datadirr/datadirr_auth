
import 'datadirr_auth_platform_interface.dart';

class DatadirrAuth {
  Future<String?> getPlatformVersion() {
    return DatadirrAuthPlatform.instance.getPlatformVersion();
  }
}
