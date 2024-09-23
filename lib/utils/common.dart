import 'dart:developer' as dev;
import 'dart:io';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/constants.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/plugin.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_widget_function/function/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Common {
  Common._();

  static logView(Map<String, String>? body) {
    if (body != null) {
      String logStr = "";
      for (var obj in body.entries) {
        logStr = "$logStr${obj.key}:${obj.value}\n";
      }
      dev.log(logStr);
    } else {
      dev.log("NULL");
    }
  }

  static Future<String> getDeviceId() async {
    if (Platform.isAndroid) {
      return ((await DeviceInfoPlugin().androidInfo).id);
    } else if (Platform.isIOS) {
      return ((await DeviceInfoPlugin().iosInfo).identifierForVendor) ?? "";
    } else if (Platform.isWindows) {
      return ((await DeviceInfoPlugin().windowsInfo).deviceId) ?? "";
    } else {
      return "";
    }
  }

  static setOnlyPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  static showSnackBar(String message, {bool error = true}) {
    Future.delayed(Duration.zero, () {
      if (kScaffoldMessengerKey.currentState != null) {
        kScaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            content:
                Text(message, style: Styles.txtRegular(color: Colorr.white)),
            duration: const Duration(seconds: 2)));
      }
    });
  }

  static Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  static bool contains(String str1, String str2, {bool ignoreCase = true}) {
    if (ignoreCase) {
      return (str1.toLowerCase().contains(str2.toLowerCase()));
    } else {
      return (str1.contains(str2));
    }
  }

  static String trim(String? str) {
    return str.toString().trim();
  }

  static bool isStringTrue(String value) {
    if (Utils.equals(value, "true") || Utils.equals(value, "1")) {
      return true;
    } else {
      return false;
    }
  }

  static void showConfirmDialog(
      BuildContext context, Function(bool confirm) confirm,
      {String? title,
      String? message,
      String? positiveButtonName,
      String? negativeButtonName,
      Color? positiveButtonColor,
      Color? negativeButtonColor,
      bool dismissible = true}) {
    showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (ctx) {
          return PopScope(
            canPop: dismissible,
            onPopInvokedWithResult: (didPop, result) {
              confirm(false);
              return;
            },
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.dialogRadius)),
              elevation: Constants.dialogElevation,
              backgroundColor: Constants.dialogBackgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Text(title ?? Plugin.company,
                              textAlign: TextAlign.center,
                              style:
                                  Styles.txtMedium(fontSize: Fonts.fontXLarge)),
                          const VSpace(space: 5),
                          Text(message ?? Strings.areYouSure,
                              textAlign: TextAlign.center,
                              style: Styles.txtRegular()),
                        ],
                      ),
                    ),
                    const CDivider(),
                    Column(
                      children: [
                        CButton(
                            text: Strings.bYes,
                            backColor: Colorr.white,
                            textStyle: Styles.txtRegular(
                                fontSize: Fonts.fontLarge,
                                color: Colorr.primaryBlue),
                            onTap: () {
                              Navigator.pop(context);
                              confirm(true);
                            }),
                        const CDivider(),
                        CButton(
                            text: Strings.bNo,
                            backColor: Colorr.white,
                            textStyle: Styles.txtRegular(
                                fontSize: Fonts.fontLarge,
                                color: Colorr.grey50),
                            onTap: () {
                              Navigator.pop(context);
                              confirm(false);
                            }),
                      ],
                    ),
                    const VSpace(space: 5),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showCustomDialog(BuildContext context,
      {bool outsideDismissible = false, Widget? child}) {
    showDialog(
        context: context,
        barrierDismissible: outsideDismissible,
        builder: (ctx) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.dialogRadius)),
              elevation: Constants.dialogElevation,
              backgroundColor: Constants.dialogBackgroundColor,
              child: child);
        });
  }

  static Key pageStorageKey({String value = "list"}) {
    return PageStorageKey<String>(value);
  }
}
