import 'package:datadirr_auth/api/api.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/convert.dart';
import 'package:datadirr_auth/utils/strings.dart';

class Auth {
  String token;
  String deviceId;
  String firstName;
  String middleName;
  String lastName;
  String email;

  Auth(
      {this.token = "",
      this.deviceId = "",
      this.firstName = "",
      this.middleName = "",
      this.lastName = "",
      this.email = ""});

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
        token: json['token'] ?? "",
        deviceId: json['deviceId'] ?? "",
        firstName: json['firstName'] ?? "",
        middleName: json['middleName'] ?? "",
        lastName: json['lastName'] ?? "",
        email: json['email'] ?? "");
  }

  static fromJsonToList(dynamic list) {
    return (list ?? []).map<Auth>((json) => Auth.fromJson(json)).toList();
  }

  static Future<Auth> signInWithUniqueID({required String uniqueID}) async {
    Auth auth = Auth();
    var body = {"uniqueID": Convert.stringToBase64(uniqueID)};
    dynamic res = await Api.request(
        cName: Api.cAuth, fName: Api.fSignInWithUniqueID, body: body);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auth = Auth.fromJson(Api.result(res)["auth"]);
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auth;
  }

  static Future<String> signIn(
      {required String deviceId,
      required String uniqueID,
      required String password}) async {
    String token = "";
    var body = {
      "deviceId": deviceId,
      "uniqueID": Convert.stringToBase64(uniqueID),
      "password": Convert.stringToBase64(password)
    };
    dynamic res =
        await Api.request(cName: Api.cAuth, fName: Api.fSignIn, body: body);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          token = Api.result(res)["token"];
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return token;
  }

  static Future<Auth> signAuth({required String uniqueID}) async {
    Auth auth = Auth();
    var body = {"uniqueID": Convert.stringToBase64(uniqueID)};
    dynamic res = await Api.request(
        cName: Api.cAuth, fName: Api.fSignInWithUniqueID, body: body);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auth = Auth.fromJson(Api.result(res)["auth"]);
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auth;
  }
}
