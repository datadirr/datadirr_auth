import 'package:datadirr_auth/api/api.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/convert.dart';
import 'package:datadirr_auth/utils/strings.dart';

class Verification {
  Verification._();

  static Future<bool> sendOTPToEmail({required String email}) async {
    bool success = false;
    var body = {"email": Convert.stringToBase64(email)};
    dynamic res = await Api.request(
        cName: Api.cVerification, fName: Api.fSendOTPToEmail, body: body);
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

  static Future<bool> verifyOTPByEmail(
      {required String email, required String otp}) async {
    bool success = false;
    var body = {"email": Convert.stringToBase64(email), "otp": otp};
    dynamic res = await Api.request(
        cName: Api.cVerification, fName: Api.fVerifyOTPByEmail, body: body);
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
