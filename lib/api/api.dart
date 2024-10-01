import 'dart:convert';
import 'dart:io';
import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/plugin.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:http/http.dart' as http;

class Api {
  Api._();

  // body params
  static const String sc = 'Class';
  static const String sf = 'Function';

  static const String deviceType = 'deviceType';
  static const String action = 'action';
  static const String actionType = 'actionType';
  static const String fileElement = 'fileArray';
  static const String deletedAttachmentArray = 'deleteAttachmentArray';

  // systemClass
  static const String cCountry = 'Country';
  static const String cAuth = 'Auth';
  static const String cVerification = 'Verification';

  // systemFunction
  static const String fCountries = 'countries';
  static const String fSignUp = 'signup';
  static const String fSendOTPToEmail = 'sendOTPToEmail';
  static const String fVerifyOTPByEmail = 'verifyOTPByEmail';
  static const String fResetPassword = 'resetPassword';
  static const String fSignInWithUniqueID = 'signInWithUniqueID';
  static const String fSignIn = 'signIn';
  static const String fSignOut = 'signOut';
  static const String fSignOutAll = 'signOutAll';
  static const String fSignAuth = 'signAuth';
  static const String fAuthLinkedByDevice = 'authLinkedByDevice';
  static const String fAuthDataByUniqueID = 'authDataByUniqueID';

  //body params
  static const String bUniqueID = 'uniqueID';
  static const String bAuthID = 'authID';

  static Future<dynamic> request(
      {required String cName,
      required String fName,
      Map<String, String>? body,
      bool isMultipartRequest = false,
      String fileDataParam = 'File'}) async {
    bool isNetwork = await Common.isNetworkConnected();
    if (!isNetwork) {
      Common.showSnackBar(Strings.noInternet);
      return null;
    }

    String token = (await Auth.currentAuthToken()) ?? "";
    if (isMultipartRequest) {
      /*String baseUrl = "${App.serverUrl}${Constants.apiPath}$call/${App.sessions.payCode}/${App.sessions.databaseName}";
        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Platform': Platform.operatingSystem,
          'Class': cName,
          'Function': fName,
          'Authorization': Sessions.token
        };

        var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
        request.headers.addAll(headers);
        //request.fields.addAll(body);
        if (fileDataList != null) {
          for (int i = 0; i < fileDataList.length; i++) {
            if (!Utils.isNullOREmpty(fileDataList[i].filePath)) {
              request.files.add(await http.MultipartFile.fromPath(
                  '$fileDataParam[$i]', fileDataList[i].filePath,
                  filename: Files.getFileName(fileDataList[i].fileName),
                  contentType: MediaType.parse(fileDataList[i].fileMimeType)));
            }
          }
        }

        return await request.send().then((response) async {
          try {
            if (response.statusCode == HttpStatus.ok) {
              dynamic res =
              jsonDecode((await http.Response.fromStream(response)).body);
              if (Utils.equals(Api.message(res), Constants.msgSessionExpired)) {
                await Sessions.sessionExpired();
                return null;
              } else {
                return res;
              }
            } else {
              Common.showToast(Strings.errInvalid);
              return null;
            }
          } catch (e) {
            Common.showToast(Strings.errServer);
            return null;
          }
        });*/
    } else {
      try {
        Map<String, String> headers = {
          'AppID': Plugin.packageName,
          'AccessKey': Plugin.accessKey,
          'Platform': Platform.operatingSystem,
          'DeviceId': Plugin.deviceId,
          'Class': cName,
          'Function': fName,
          'Authorization': token
        };

        Common.logView(headers);

        final response = await http.post(Uri.parse(Plugin.baseURL),
            headers: headers, body: body);

        if (response.statusCode == HttpStatus.ok) {
          dynamic res = jsonDecode(response.body);
          if (Api.resNotNull(res)) {
            if (Api.forceLogout(res)) {
              // force logout
              Common.showSnackBar(Api.message(res));
              /*if (kNavigatorKey.currentContext!.mounted) {
                Navigator.pushReplacement(
                    kNavigatorKey.currentContext!,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()));
              }*/
              return null;
            } else {
              return res;
            }
          } else {
            Common.showSnackBar(Strings.errResponseFailed);
            return null;
          }
        } else {
          Common.showSnackBar(Strings.errInvalid);
          return null;
        }
      } catch (e) {
        Common.showSnackBar(Strings.errServer);
        return null;
      }
    }
  }

  static bool resNotNull(dynamic res) {
    if (res != null) {
      return true;
    } else {
      return false;
    }
  }

  static bool resultOk(dynamic res) {
    if (res['resultCode'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  static bool forceLogout(dynamic res) {
    if (res['resultCode'] == 2) {
      return true;
    } else {
      return false;
    }
  }

  static message(dynamic res) {
    return res['message'] ?? "";
  }

  static dynamic result(dynamic res) {
    return res['result'];
  }
}
