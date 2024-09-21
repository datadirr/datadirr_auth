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
  final String deviceId;
  final Function(BuildContext context, String token) onSuccess;

  const SignInScreen(
      {super.key, required this.deviceId, required this.onSuccess});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _loading = false;
  final TextEditingController _conEmail = TextEditingController();
  final TextEditingController _conPassword = TextEditingController();
  bool _isPasswordVisible = false;

  Auth _auth = Auth();

  bool _isEmail = false;
  bool _isPassword = false;

  @override
  void initState() {
    super.initState();
    _isEmail = true;
  }

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
        home: PopScope(
          canPop: _isEmail,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              return;
            }
            _back();
          },
          child: Touch(
            disable: _loading,
            child: Scaffold(
              body: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const VSpace(space: 20),
                          Image.asset(Assets.imgDatadirrTxt,
                              width: 100, package: Plugin.package),
                          const VSpace(space: 20),
                          _emailUI(),
                          _passwordUI(),
                        ]),
                      ),
                    ),
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
        ),
      ),
    );
  }

  _emailUI() {
    return Visibility(
      visible: _isEmail,
      child: Column(
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
      ),
    );
  }

  _passwordUI() {
    return Visibility(
      visible: _isPassword,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${_auth.firstName} ${_auth.lastName}",
              style: Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
          const VSpace(),
          Tap(
            onTap: () {
              _back();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfileUI(
                    value: _auth.firstName, size: 25, fontSize: Fonts.fontSmall),
                const HSpace(space: 10),
                Flexible(
                  child: Text(_auth.email,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.txtRegular(color: Colorr.primaryBlue)),
                ),
              ],
            ),
          ),
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
                  child: Text(Strings.forgotPassword,
                      style: Styles.txtMedium(color: Colorr.primaryBlue))))
        ],
      ),
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
      String password = _conPassword.trimText();
      if (Utils.isNullOREmpty(email)) {
        Common.showSnackBar(Strings.errInvalid);
        return;
      }
      if (Utils.isNullOREmpty(password)) {
        Common.showSnackBar(Strings.plzEnterPassword);
        return;
      }
      _signIn(email, password);
    }
  }

  _signInWithUniqueID(String email) async {
    setState(() {
      _loading = true;
    });
    _auth = await Auth.signInWithUniqueID(uniqueID: email);
    if (!Utils.isNullOREmpty(_auth.email)) {
      _continue();
    }
    setState(() {
      _loading = false;
    });
  }

  _signIn(String email, String password) async {
    setState(() {
      _loading = true;
    });
    String token = await Auth.signIn(
        deviceId: widget.deviceId, uniqueID: email, password: password);
    if (!Utils.isNullOREmpty(token)) {
      widget.onSuccess(context, token);
    }
    setState(() {
      _loading = false;
    });
  }

  _continue() async {
    setState(() {
      if (_isEmail) {
        _isEmail = false;
        _isPassword = true;
      }
    });
  }

  _back() async {
    setState(() {
      if (_isPassword) {
        _isEmail = true;
        _isPassword = false;
        _reset();
      }
    });
  }

  _reset() async {
    _auth = Auth();
    _conEmail.clear();
    _conPassword.clear();
  }
}
