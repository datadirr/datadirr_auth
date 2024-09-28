import 'package:datadirr_auth/utils/common.dart';

import 'datadirr_auth_platform_interface.dart';

class DatadirrAuth {
  String _dd = "";
  String deviceId = "";
  String appID = "";
  String accessKey = "";
  String token = "";
  static DatadirrAuth datadirrInit = DatadirrAuth();
  static DatadirrAuth datadirrSetup = DatadirrAuth();

  static init({required String appID, required String accessKey}) async {
    DatadirrAuth datadirrAuth = DatadirrAuth();
    datadirrAuth.deviceId = await Common.getDeviceId();
    datadirrAuth.appID = appID;
    datadirrAuth.accessKey = accessKey;
    DatadirrAuth.datadirrInit = datadirrAuth;
  }

  static setup({required String token}) async {
    DatadirrAuth datadirrAuth = DatadirrAuth();
    datadirrAuth.token = token;
    DatadirrAuth.datadirrSetup = datadirrAuth;
  }

  Future<String?> getPlatformVersion() {
    return DatadirrAuthPlatform.instance.getPlatformVersion();
  }
}
