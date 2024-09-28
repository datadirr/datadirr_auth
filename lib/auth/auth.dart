import 'package:datadirr_auth/api/api.dart';
import 'package:datadirr_auth/datadirr_auth.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/convert.dart';
import 'package:datadirr_auth/utils/strings.dart';

class Auth {
  String token;
  String deviceId;
  String authID;
  String username;
  String email;
  String mobile;
  String name;
  String fullName;
  String firstName;
  String middleName;
  String lastName;

  Auth(
      {this.token = "",
      this.deviceId = "",
      this.authID = "",
      this.username = "",
      this.email = "",
      this.mobile = "",
      this.name = "",
      this.fullName = "",
      this.firstName = "",
      this.middleName = "",
      this.lastName = ""});

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
        token: json['token'] ?? "",
        deviceId: json['deviceId'] ?? "",
        authID: json['deviceId'] ?? "",
        username: json['username'] ?? "",
        email: json['email'] ?? "",
        mobile: json['mobile'] ?? "",
        name: json['name'] ?? "",
        fullName: json['fullName'] ?? "",
        firstName: json['firstName'] ?? "",
        middleName: json['middleName'] ?? "",
        lastName: json['lastName'] ?? "");
  }

  static fromJsonToList(dynamic list) {
    return (list ?? []).map<Auth>((json) => Auth.fromJson(json)).toList();
  }

  static Future<Auth?> signInWithUniqueID(
      {required String uniqueID, bool showErr = true}) async {
    Auth? auth;
    var body = {"uniqueID": Convert.stringToBase64(uniqueID)};
    dynamic res = await Api.request(
        cName: Api.cAuth, fName: Api.fSignInWithUniqueID, body: body);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auth = Auth.fromJson(Api.result(res)["auth"]);
        } else {
          if (showErr) {
            Common.showSnackBar(Api.message(res));
          }
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auth;
  }

  static Future<bool> resetPassword(
      {required String email, required String password}) async {
    bool success = false;
    var body = {
      "uniqueID": Convert.stringToBase64(email),
      "password": Convert.stringToBase64(password)
    };
    dynamic res = await Api.request(
        cName: Api.cAuth, fName: Api.fResetPassword, body: body);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          Common.showSnackBar(Api.message(res));
          success = true;
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return success;
  }

  static Future<bool> signup(
      {required String firstName,
      required String middleName,
      required String lastName,
      required String mobile,
      required String email,
      required String password}) async {
    bool success = false;
    var body = {
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "mobile": mobile,
      "email": Convert.stringToBase64(email),
      "password": Convert.stringToBase64(password)
    };
    dynamic res =
        await Api.request(cName: Api.cAuth, fName: Api.fSignUp, body: body);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          Common.showSnackBar(Api.message(res));
          success = true;
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return success;
  }

  static Future<Auth?> signIn(
      {required String uniqueID, required String password}) async {
    Auth? auth;
    var body = {
      "uniqueID": Convert.stringToBase64(uniqueID),
      "password": Convert.stringToBase64(password)
    };
    dynamic res =
        await Api.request(cName: Api.cAuth, fName: Api.fSignIn, body: body);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auth = Auth.fromJson(Api.result(res)["auth"]);
          DatadirrAuth.setup(token: auth.token);
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auth;
  }

  static Future<Auth> signAuth() async {
    Auth auth = Auth();
    dynamic res = await Api.request(cName: Api.cAuth, fName: Api.fSignAuth);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auth = Auth.fromJson(Api.result(res)["auth"]);
          DatadirrAuth.setup(token: auth.token);
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auth;
  }

  static Future<List<Auth>> authLinkedByDevice() async {
    List<Auth> auths = [];
    dynamic res =
        await Api.request(cName: Api.cAuth, fName: Api.fAuthLinkedByDevice);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auths = Auth.fromJsonToList(Api.result(res)["auths"]);
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auths;
  }

  static Future<List<Auth>> searchAuth(String uniqueID) async {
    List<Auth> auths = [];
    var body = {Api.bUniqueID: Convert.stringToBase64(uniqueID)};
    dynamic res = await Api.request(
        cName: Api.cAuth, fName: Api.fAuthDataByUniqueID, body: body);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auths = Auth.fromJsonToList(Api.result(res)["auths"]);
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auths;
  }

  static Future<bool> signOut() async {
    bool success = false;
    dynamic res = await Api.request(cName: Api.cAuth, fName: Api.fSignOut);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          success = true;
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return success;
  }

  static Future<bool> signOutAll() async {
    bool success = false;
    dynamic res = await Api.request(cName: Api.cAuth, fName: Api.fSignOutAll);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          success = true;
        } else {
          Common.showSnackBar(Api.message(res));
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return success;
  }
}
