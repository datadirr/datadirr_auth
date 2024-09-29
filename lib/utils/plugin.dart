import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/db.dart';

class Plugin {
  Plugin._();

  static const String package = "datadirr_auth";
  static const String company = "datadirr";

  static const String baseURL = "http://192.168.69.114/api_datadirr/";

  static String packageName = "";
  static String deviceId = "";
  static String accessKey = "";

  static set() async {
    Plugin.packageName = await Common.getPackageName();
    Plugin.deviceId = await Common.getDeviceId();
    Plugin.accessKey = (await DB.db.getString(DB.kAccessKey)) ?? "";
  }
}
