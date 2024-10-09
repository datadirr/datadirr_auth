import 'dart:convert';
import 'package:datadirr_auth/api/api.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/convert.dart';
import 'package:datadirr_auth/utils/db.dart';
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
  String birthdate;
  String genderId;
  String genderName;
  String countryId;
  String countryName;
  String countryIdForMobile;
  String countryPhoneCodePlus;
  String profileImage;

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
      this.lastName = "",
      this.birthdate = "",
      this.genderId = "",
      this.genderName = "",
      this.countryId = "",
      this.countryName = "",
      this.countryIdForMobile = "",
      this.countryPhoneCodePlus = "",
      this.profileImage = ""});

  factory Auth.fromMap(Map<String, dynamic> obj) {
    return Auth(
        token: obj['token'] ?? "",
        deviceId: obj['deviceId'] ?? "",
        authID: obj['authID'] ?? "",
        username: obj['username'] ?? "",
        email: obj['email'] ?? "",
        mobile: obj['mobile'] ?? "",
        name: obj['name'] ?? "",
        fullName: obj['fullName'] ?? "",
        firstName: obj['firstName'] ?? "",
        middleName: obj['middleName'] ?? "",
        lastName: obj['lastName'] ?? "",
        birthdate: obj['birthdate'] ?? "",
        genderId: obj['genderId'] ?? "",
        genderName: obj['genderName'] ?? "",
        countryId: obj['countryId'] ?? "",
        countryName: obj['countryName'] ?? "",
        countryIdForMobile: obj['countryIdForMobile'] ?? "",
        countryPhoneCodePlus: obj['countryPhoneCodePlus'] ?? "",
        profileImage: obj['profileImage'] ?? "");
  }

  static Map<String, dynamic> toMap(Auth auth) => {
        "token": auth.token,
        "deviceId": auth.deviceId,
        "authID": auth.authID,
        "username": auth.username,
        "email": auth.email,
        "mobile": auth.mobile,
        "name": auth.name,
        "fullName": auth.fullName,
        "firstName": auth.firstName,
        "middleName": auth.middleName,
        "lastName": auth.lastName,
        "birthdate": auth.birthdate,
        "genderId": auth.genderId,
        "genderName": auth.genderName,
        "countryId": auth.countryId,
        "countryName": auth.countryName,
        "countryIdForMobile": auth.countryIdForMobile,
        "countryPhoneCodePlus": auth.countryPhoneCodePlus,
        "profileImage": auth.profileImage
      };

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
        token: json['token'] ?? "",
        deviceId: json['deviceId'] ?? "",
        authID: json['authID'] ?? "",
        username: json['username'] ?? "",
        email: json['email'] ?? "",
        mobile: json['mobile'] ?? "",
        name: json['name'] ?? "",
        fullName: json['fullName'] ?? "",
        firstName: json['firstName'] ?? "",
        middleName: json['middleName'] ?? "",
        lastName: json['lastName'] ?? "",
        birthdate: json['birthdate'] ?? "",
        genderId: json['genderId'] ?? "",
        genderName: json['genderName'] ?? "",
        countryId: json['countryId'] ?? "",
        countryName: json['countryName'] ?? "",
        countryIdForMobile: json['countryIdForMobile'] ?? "",
        countryPhoneCodePlus: json['countryPhoneCodePlus'] ?? "",
        profileImage: json['profileImage'] ?? "");
  }

  static fromJsonToList(dynamic list) {
    return (list ?? []).map<Auth>((json) => Auth.fromJson(json)).toList();
  }

  static Future<Auth?> getAuth() async {
    String? value = await DB.db.getString(DB.kCurrentAuth);
    if (value != null) {
      var obj = jsonDecode(value);
      Auth auth = Auth.fromMap(obj);
      return auth;
    } else {
      return null;
    }
  }

  static setCurrentAuth(Auth? auth) async {
    if (auth != null) {
      String value = jsonEncode(Auth.toMap(auth));
      await DB.db.setString(DB.kCurrentAuth, value);
    }
  }

  static Future<Auth?> currentAuth() async {
    Auth? auth = await Auth.getAuth();
    if (auth == null) {
      return null;
    }
    bool isNetwork = await Common.isNetworkConnected();
    if (!isNetwork) {
      return auth;
    }
    dynamic res = await Api.request(cName: Api.cAuth, fName: Api.fSignAuth);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auth = Auth.fromJson(Api.result(res)["auth"]);
        } else {
          await Auth.removeAuth();
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auth;
  }

  static removeAuth() async {
    await DB.db.remove(DB.kCurrentAuth);
  }

  static Future<Auth?> signAuth() async {
    Auth? auth;
    dynamic res = await Api.request(cName: Api.cAuth, fName: Api.fSignAuth);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auth = Auth.fromJson(Api.result(res)["auth"]);
        }
      }
    } catch (_) {
      Common.showSnackBar(Strings.errDataParse);
    }
    return auth;
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
      required String birthdate,
      required String genderId,
      required String countryId,
      required String countryIdForMobile,
      required String mobile,
      required String email,
      required String password}) async {
    bool success = false;
    var body = {
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "birthdate": birthdate,
      "genderId": genderId,
      "countryId": countryId,
      "countryIdForMobile": countryIdForMobile,
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
    String deviceName = await Common.getDeviceName();
    var body = {
      "uniqueID": Convert.stringToBase64(uniqueID),
      "password": Convert.stringToBase64(password),
      "deviceName": deviceName
    };
    dynamic res =
        await Api.request(cName: Api.cAuth, fName: Api.fSignIn, body: body);
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

  static Future<List<Auth>> authLinkedByDevice() async {
    List<Auth> auths = [];
    dynamic res =
        await Api.request(cName: Api.cAuth, fName: Api.fAuthLinkedByDevice);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          auths = Auth.fromJsonToList(Api.result(res)["auths"]);
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
          await Auth.removeAuth();
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
          await Auth.removeAuth();
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

  static Future<bool> changeName(
      {required String authID,
      required String firstName,
      required String middleName,
      required String lastName}) async {
    bool success = false;
    var body = {
      "authID": authID,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName
    };
    dynamic res =
        await Api.request(cName: Api.cAuth, fName: Api.fChangeName, body: body);
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

  static Future<bool> changeBirthdate(
      {required String authID, required String birthdate}) async {
    bool success = false;
    var body = {"authID": authID, "birthdate": birthdate};
    dynamic res = await Api.request(
        cName: Api.cAuth, fName: Api.fChangeBirthdate, body: body);
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

  static Future<bool> changeGender(
      {required String authID, required String genderId}) async {
    bool success = false;
    var body = {"authID": authID, "genderId": genderId};
    dynamic res = await Api.request(
        cName: Api.cAuth, fName: Api.fChangeGender, body: body);
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

  static Future<bool> changeMobile(
      {required String authID,
      required String countryIdForMobile,
      required String mobile}) async {
    bool success = false;
    var body = {
      "authID": authID,
      "countryIdForMobile": countryIdForMobile,
      "mobile": mobile
    };
    dynamic res = await Api.request(
        cName: Api.cAuth, fName: Api.fChangeMobile, body: body);
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

  static Future<bool> changePassword(
      {required String authID,
      required String oldPassword,
      required String password}) async {
    bool success = false;
    var body = {
      "authID": authID,
      "oldPassword": Convert.stringToBase64(oldPassword),
      "password": Convert.stringToBase64(password)
    };
    dynamic res = await Api.request(
        cName: Api.cAuth, fName: Api.fChangePassword, body: body);
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
}
