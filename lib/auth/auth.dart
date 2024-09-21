import 'package:datadirr_auth/api/api.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/convert.dart';
import 'package:datadirr_auth/utils/strings.dart';

class Auth {
  String firstName;
  String middleName;
  String lastName;
  String email;

  Auth(
      {this.firstName = "",
      this.middleName = "",
      this.lastName = "",
      this.email = ""});

  factory Auth._fromJson(Map<String, dynamic> json) {
    return Auth(
        firstName: json['firstName'] ?? "",
        middleName: json['middleName'] ?? "",
        lastName: json['lastName'] ?? "",
        email: json['email'] ?? "");
  }

  static fromJsonToList(dynamic list) {
    return (list ?? []).map<Auth>((json) => Auth._fromJson(json)).toList();
  }

  static Future<Auth> signInWithUniqueID(
      {required String uniqueID}) async {
    Auth auth = Auth();
    var body = {"uniqueID": Convert.stringToBase64(uniqueID)};
    dynamic res = await Api.request(
        cName: Api.cAuth, fName: Api.fSignInWithUniqueID, body: body);
    try {
      if (Api.resNotNull(res)) {
        if (Api.resultOk(res)) {
          var data = Api.result(res)["auth"];
          auth.firstName = data['firstName'];
          auth.middleName = data['middleName'];
          auth.lastName = data['lastName'];
          auth.email = data['email'];
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
