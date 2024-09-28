import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/auth/sign_up.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_function/function/extension.dart';
import 'package:flutter_widget_function/function/utils.dart';
import 'package:flutter_widget_function/widget/keyboard/keyboard_dismiss.dart';
import 'package:flutter_widget_function/widget/responsive/responsive_layout.dart';

class SignIn extends StatefulWidget {
  final Function(BuildContext context, Auth auth) onSuccess;
  final Function()? onBack;

  const SignIn({super.key, required this.onSuccess, this.onBack});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _loading = false;
  final TextEditingController _conEmail = TextEditingController();
  final TextEditingController _conPassword = TextEditingController();
  bool _isPasswordVisible = false;

  Auth? _auth = Auth();

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
      child: PopScope(
        canPop: (_isEmail && !_loading),
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          _back();
        },
        child: Touch(
          disable: _loading,
          child: Scaffold(
            backgroundColor: Colorr.white,
            body: SafeArea(
                child: Column(
              children: [
                Visibility(visible: _loading, child: const LProgress()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const VSpace(space: 20),
                                  const CImage(Assets.imgDatadirrTxt,
                                      width: 100),
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
                                text:
                                    _isPassword ? Strings.finish : Strings.next,
                                loading: _loading,
                                onTap: () {
                                  if (!_loading) {
                                    _checkValidDetails();
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
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
              textAlign: TextAlign.center,
              style: Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
          const VSpace(space: 5),
          Text(Strings.withYourDatadirrAccount,
              textAlign: TextAlign.center, style: Styles.txtRegular()),
          const VSpace(space: 30),
          CATextField(
            controller: _conEmail,
            hintText: Strings.email,
          ),
          const VSpace(space: 50),
          Align(
              alignment: Alignment.centerLeft,
              child: Tap(
                  onTap: () {
                    if (!_loading) {
                      _gotoSignUp();
                    }
                  },
                  child: Text(Strings.createAccount,
                      style: Styles.txtMedium(color: Colorr.primaryBlue)))),
          const VSpace(space: 30),
        ],
      ),
    );
  }

  _passwordUI() {
    return Visibility(
      visible: _isPassword,
      child: (_auth == null)
          ? Container()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_auth!.name,
                    textAlign: TextAlign.center,
                    style: Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
                const VSpace(space: 5),
                Tap(
                  onTap: () {
                    _back();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileUI(
                          value: _auth!.name,
                          size: 25,
                          fontSize: Fonts.fontSmall),
                      const HSpace(),
                      Flexible(
                        child: Text(_auth!.email,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Styles.txtRegular(color: Colorr.primaryBlue)),
                      ),
                    ],
                  ),
                ),
                const VSpace(space: 30),
                CATextField(
                  controller: _conPassword,
                  hintText: Strings.enterYourPassword,
                  obscureText: !_isPasswordVisible,
                  suffixImage: _isPasswordVisible
                      ? Assets.imgVisible
                      : Assets.imgInvisible,
                  suffixImageTap: () {
                    if (mounted) {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    }
                  },
                ),
                const VSpace(space: 50),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Tap(
                        onTap: () {
                          if (!_loading) {
                            _gotoForgotPassword();
                          }
                        },
                        child: Text(Strings.forgotPassword,
                            style:
                                Styles.txtMedium(color: Colorr.primaryBlue)))),
                const VSpace(space: 30),
              ],
            ),
    );
  }

  _checkValidDetails() {
    String email = _conEmail.trimText();
    String password = _conPassword.trimText();
    if (_isEmail) {
      if (Utils.isNullOREmpty(email)) {
        Common.showSnackBar(Strings.plzEnterEmail);
        return;
      }
      _signInWithUniqueID(email);
    } else if (_isPassword) {
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
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    _auth = await Auth.signInWithUniqueID(uniqueID: email);
    if (_auth != null) {
      _continue();
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  _signIn(String email, String password) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    Auth? auth = await Auth.signIn(uniqueID: email, password: password);
    if (auth != null && mounted) {
      widget.onSuccess(context, auth);
    } else {
      Common.showSnackBar(Strings.plzTryAgain);
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  _continue() async {
    if (mounted) {
      setState(() {
        if (_isEmail) {
          _isEmail = false;
          _isPassword = true;

          _isPasswordVisible = false;
          _conPassword.clear();
        }
      });
    }
  }

  _back() async {
    if (!_loading) {
      if (mounted) {
        setState(() {
          if (_isPassword) {
            _isEmail = true;
            _isPassword = false;

            _auth = null;
          }
        });
      }
    }
  }

  _gotoSignUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignUp()));
  }

  _gotoForgotPassword() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignUp()));
  }
}
