import 'datadirr_auth_platform_interface.dart';

class DatadirrAuth {
  static String appID = "";
  static String accessKey = "";
  static init({required String appID, required String accessKey}) async {
    DatadirrAuth.appID = appID;
    DatadirrAuth.accessKey = accessKey;
  }

  Future<String?> getPlatformVersion() {
    return DatadirrAuthPlatform.instance.getPlatformVersion();
  }
}
