import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/auth/manage/manage_birthdate.dart';
import 'package:datadirr_auth/auth/manage/manage_gender.dart';
import 'package:datadirr_auth/auth/manage/manage_mobile.dart';
import 'package:datadirr_auth/auth/manage/manage_name.dart';
import 'package:datadirr_auth/auth/manage/manage_password.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:date_time_plus/date_times.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_function/widget/keyboard/keyboard_dismiss.dart';

class ManageAccount extends StatefulWidget {
  final Auth auth;

  const ManageAccount({super.key, required this.auth});

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  bool _loading = false;
  Auth _auth = Auth();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _auth = widget.auth;
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    _auth = (await Auth.currentAuth()) ?? Auth();
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Touch(
      disable: _loading,
      child: KeyboardDismiss(
        child: Scaffold(
          backgroundColor: Colorr.white,
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const VSpace(space: 30),
                ProfileUI(
                    value: _auth.name,
                    size: 80,
                    radius: 50,
                    fontSize: Fonts.fontXXXLarge),
                const VSpace(),
                Text(_auth.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.txtMedium(fontSize: Fonts.fontXXLarge)),
                Text(_auth.email,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.txtRegular()),
                CTextButton(text: Strings.signOut, onTap: () {
                  _signOut();
                }),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const CDivider(),
                      const VSpace(space: 30),
                      _title(
                          title: Strings.basicInfo,
                          icon: Assets.icPersonalInfo),
                      const VSpace(),
                      _subTitle(message: Strings.basicInfoMsg),
                      const VSpace(space: 30),
                      Row(
                        children: [
                          Expanded(
                            child: _itemRow(
                                title: Strings.profilePicture.toUpperCase(),
                                value: Strings.profilePictureChangesMsg),
                          ),
                          ProfileUI(
                              value: _auth.name,
                              size: 50,
                              radius: 30,
                              fontSize: Fonts.fontXXLarge)
                        ],
                      ),
                      const VSpace(space: 30),
                      _itemRow(
                          onTap: () {
                            _manageName();
                          },
                          title: Strings.name.toUpperCase(),
                          value: _auth.fullName),
                      const VSpace(space: 30),
                      _itemRow(
                          onTap: () {
                            _manageBirthdate();
                          },
                          title: Strings.birthdate.toUpperCase(),
                          value: DateTimes.formatDateTime(
                              dateTime: _auth.birthdate,
                              inFormat: Format.fyyyyMMdd,
                              outFormat: Format.fddMMMyyyy)),
                      const VSpace(space: 30),
                      _itemRow(
                          onTap: () {
                            _manageGender();
                          },
                          title: Strings.gender.toUpperCase(),
                          value: _auth.genderName),
                      const VSpace(space: 30),
                      _itemRow(
                          title: Strings.region.toUpperCase(),
                          value: _auth.countryName),
                      const VSpace(space: 30),
                      const CDivider(),
                      const VSpace(space: 30),
                      _title(title: Strings.contactInfo, icon: Assets.icMobile),
                      const VSpace(),
                      _subTitle(message: Strings.contactInfoMsg),
                      const VSpace(space: 30),
                      _itemRow(
                          title: Strings.email.toUpperCase(),
                          value: _auth.email),
                      const VSpace(space: 30),
                      _itemRow(
                          onTap: () {
                            _manageMobile();
                          },
                          title: Strings.phone.toUpperCase(),
                          value:
                              "${_auth.countryPhoneCodePlus}${_auth.mobile}"),
                      const VSpace(space: 30),
                      const CDivider(),
                      const VSpace(space: 30),
                      _title(title: Strings.security, icon: Assets.icLock),
                      const VSpace(),
                      _subTitle(message: Strings.securityInfoMsg),
                      const VSpace(space: 30),
                      _itemRow(
                          onTap: () {
                            _managePassword();
                          },
                          title: Strings.password.toUpperCase(),
                          value: "*****"),
                      const VSpace(space: 30),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  _title({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const HSpace(),
        Flexible(
          child: Text(title,
              overflow: TextOverflow.ellipsis, style: Styles.txtMedium()),
        ),
      ],
    );
  }

  _subTitle({required String message}) {
    return Text(message, style: Styles.txtRegular(color: Colorr.grey50));
  }

  _itemRow({required String title, required String value, Function()? onTap}) {
    return Tap(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.txtRegular(
                        color: Colorr.grey50, fontSize: Fonts.fontXSmall)),
                Text(value, style: Styles.txtRegular()),
              ],
            ),
          ),
          const HSpace(),
          Visibility(
              visible: (onTap != null),
              child: const Icon(Assets.icArrowForward, size: 15))
        ],
      ),
    );
  }

  _manageName() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => ManageName(auth: _auth)))
        .then(_success);
  }

  _manageBirthdate() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManageBirthdate(auth: _auth))).then(_success);
  }

  _manageGender() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => ManageGender(auth: _auth)))
        .then(_success);
  }

  _manageMobile() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => ManageMobile(auth: _auth)))
        .then(_success);
  }

  _managePassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManagePassword(auth: _auth))).then(_success);
  }

  _success(dynamic value) {
    bool success = value ?? false;
    if (success) {
      _init();
    }
  }

  _signOut() async {
    Common.showConfirmDialog(context, (confirm) {
      if (confirm) {

      }
    }, title: Strings.signOut);
  }
}
