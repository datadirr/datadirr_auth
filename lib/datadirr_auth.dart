import 'package:datadirr_auth/utils/db.dart';
import 'datadirr_auth_platform_interface.dart';

class DatadirrAuth {

  static init({required String accessKey}) async {
    await DB.db.setString(DB.kAccessKey, accessKey);
  }

  static setup({required String token}) async {
    await DB.db.setString(DB.kToken, token);
  }

  Future<String?> getPlatformVersion() {
    return DatadirrAuthPlatform.instance.getPlatformVersion();
  }
}
