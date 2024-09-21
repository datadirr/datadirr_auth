import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/plugin.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_function/function/extension.dart';
import 'package:flutter_widget_function/function/utils.dart';
import 'package:flutter_widget_function/widget/keyboard/keyboard_dismiss.dart';
import 'package:flutter_widget_function/widget/responsive/responsive_layout.dart';

class SignInScreen extends StatefulWidget {
  final Function()? onSuccess;
  final Function()? onFailure;

  const SignInScreen({super.key, this.onSuccess, this.onFailure});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _loading = false;
  final TextEditingController _conEmail = TextEditingController();
  final TextEditingController _conPassword = TextEditingController();
  bool _isPasswordVisible = false;

  Auth _auth = Auth();

  /*@override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
      child: MaterialApp(
        navigatorKey: kNavigatorKey,
        scaffoldMessengerKey: kScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colorr.primary,
              primary: Colorr.primary,
              surface: Colorr.white),
          scaffoldBackgroundColor: Colorr.white,
          useMaterial3: true,
        ),
        home: Scaffold(
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(mainAxisSize: MainAxisSize.min, children: [
                  const VSpace(space: 20),
                  Image.asset(Assets.imgDatadirrTxt,
                      width: 100, package: Plugin.package),
                  const VSpace(space: 20),
                  Visibility(
                      visible: Utils.isNullOREmpty(_auth.email),
                      replacement: _passwordUI(),
                      child: _emailUI())
                ]),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlexWidth(
                    child: CButton(
                        text: Strings.next,
                        loading: _loading,
                        onTap: () {
                          _checkValidDetails();
                        }),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }

  _emailUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(Strings.signIn,
            style: Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
        const VSpace(),
        Text(Strings.signInMsg,
            style: Styles.txtRegular(color: Colorr.primaryBlue)),
        const VSpace(space: 30),
        CATextField(
          controller: _conEmail,
          hintText: Strings.email,
        ),
        const VSpace(space: 50),
        Align(
            alignment: Alignment.centerLeft,
            child: Tap(
                onTap: () {},
                child: Text(Strings.createAccount,
                    style: Styles.txtMedium(color: Colorr.primaryBlue))))
      ],
    );
  }

  _passwordUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(Strings.signIn,
            style: Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
        const VSpace(),
        Text(Strings.signInMsg,
            style: Styles.txtRegular(color: Colorr.primaryBlue)),
        const VSpace(space: 30),
        CATextField(
          controller: _conPassword,
          hintText: Strings.enterYourPassword,
          obscureText: !_isPasswordVisible,
          suffixImage:
              _isPasswordVisible ? Assets.imgVisible : Assets.imgInvisible,
          suffixImageTap: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        const VSpace(space: 50),
        Align(
            alignment: Alignment.centerLeft,
            child: Tap(
                onTap: () {},
                child: Text(Strings.createAccount,
                    style: Styles.txtMedium(color: Colorr.primaryBlue))))
      ],
    );
  }

  _checkValidDetails() {
    String email = _conEmail.trimText();
    if (Utils.isNullOREmpty(_auth.email)) {
      if (Utils.isNullOREmpty(email)) {
        Common.showSnackBar(Strings.plzEnterEmail);
        return;
      }
      _signInWithUniqueID(email);
    } else {

    }
  }

  _signInWithUniqueID(String email) async {
    setState(() {
      _loading = true;
    });
    _auth = await Auth.signInWithUniqueID(uniqueID: email);
    setState(() {
      _loading = false;
    });
  }
}
