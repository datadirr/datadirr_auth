import 'package:shared_preferences/shared_preferences.dart';

class DB {
  DB._();
  static const String kDeviceId = "deviceId";
  static const String kAppID = "appID";
  static const String kAccessKey = "accessKey";
  static const String kToken = "token";
  static SharedPreferencesAsync db = SharedPreferencesAsync();
}
