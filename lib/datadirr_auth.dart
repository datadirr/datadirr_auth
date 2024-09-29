import 'package:datadirr_auth/utils/db.dart';
import 'package:datadirr_auth/utils/plugin.dart';
import 'datadirr_auth_platform_interface.dart';

class DatadirrAuth {
  static init({required String accessKey}) async {
    await DB.db.setString(DB.kAccessKey, accessKey);
    await Plugin.set();
  }

  Future<String?> getPlatformVersion() {
    return DatadirrAuthPlatform.instance.getPlatformVersion();
  }
}
