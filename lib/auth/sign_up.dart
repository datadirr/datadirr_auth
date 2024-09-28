import 'package:datadirr_auth/auth/auth.dart';
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
import 'package:validation_pro/validate.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _loading = false;
  final TextEditingController _conFirstName = TextEditingController();
  final TextEditingController _conMiddleName = TextEditingController();
  final TextEditingController _conLastName = TextEditingController();
  final TextEditingController _conMobile = TextEditingController();
  final TextEditingController _conEmail = TextEditingController();
  final TextEditingController _conPassword = TextEditingController();
  bool _isPasswordVisible = false;

  bool _isPersonalDetails = false;
  bool _isEmail = false;
  bool _isPassword = false;

  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _isPersonalDetails = true;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
      child: PopScope(
        canPop: (_isPersonalDetails && !_loading),
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
                                  const CImage(
                                      assetName: Assets.imgDatadirrTxt,
                                      width: 100),
                                  const VSpace(space: 20),
                                  _personalDetailsUI(),
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

  _personalDetailsUI() {
    return Visibility(
      visible: _isPersonalDetails,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.createDatadirrAccount,
              textAlign: TextAlign.center,
              style: Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
          const VSpace(space: 5),
          Text(Strings.enterYourNameAndMobileNumber,
              textAlign: TextAlign.center, style: Styles.txtRegular()),
          const VSpace(space: 30),
          CATextField(
            controller: _conFirstName,
            hintText: Strings.firstName,
          ),
          const VSpace(),
          CATextField(
            controller: _conMiddleName,
            hintText: Strings.middleNameOptional,
          ),
          const VSpace(),
          CATextField(
            controller: _conLastName,
            hintText: Strings.lastNameSurname,
          ),
          const VSpace(),
          CATextField(
            controller: _conMobile,
            hintText: Strings.mobileNumber,
            inputType: TextInputType.number,
            inputFormatters: [Validate.intValueFormatter()],
          ),
          const VSpace(space: 30),
        ],
      ),
    );
  }

  _emailUI() {
    return Visibility(
      visible: _isEmail,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.createDatadirrAccount,
              textAlign: TextAlign.center,
              style: Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
          const VSpace(space: 5),
          Text(Strings.youWillUseEmailSignInAccount,
              textAlign: TextAlign.center, style: Styles.txtRegular()),
          const VSpace(space: 30),
          CATextField(
            controller: _conEmail,
            hintText: Strings.email,
          ),
          const VSpace(space: 20),
          Align(
              alignment: Alignment.centerLeft,
              child: Tap(
                  onTap: () {
                    if (!_loading) {

                    }
                  },
                  child: Text(Strings.verify,
                      style: Styles.txtMedium(color: Colorr.primaryBlue)))),
          const VSpace(space: 30),
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
          Text(Strings.createStrongPassword,
              textAlign: TextAlign.center,
              style: Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
          const VSpace(space: 5),
          Text(Strings.createStrongPasswordMsg,
              textAlign: TextAlign.center, style: Styles.txtRegular()),
          const VSpace(space: 30),
          CATextField(
            controller: _conPassword,
            hintText: Strings.enterYourPassword,
            obscureText: !_isPasswordVisible,
            suffixImage:
                _isPasswordVisible ? Assets.imgVisible : Assets.imgInvisible,
            suffixImageTap: () {
              if (mounted) {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }
            },
          ),
          const VSpace(),
          Align(
              alignment: Alignment.centerLeft,
              child: Tap(
                  onTap: () {},
                  child: Text(Strings.passwordValidMsg,
                      style: Styles.txtRegular(
                          color: Colorr.grey50, fontSize: Fonts.fontXSmall)))),
          const VSpace(space: 30),
        ],
      ),
    );
  }

  _checkValidDetails() {
    String firstName = _conFirstName.trimText();
    String middleName = _conMiddleName.trimText();
    String lastName = _conLastName.trimText();
    String mobile = _conMobile.trimText();
    String email = _conEmail.trimText();
    String password = _conPassword.trimText();
    if (_isPersonalDetails) {
      if (Utils.isNullOREmpty(firstName) || Utils.isNullOREmpty(lastName)) {
        Common.showSnackBar(Strings.plzEnterYourName);
        return;
      }
      if (Utils.isNullOREmpty(mobile)) {
        Common.showSnackBar(Strings.plzEnterMobileNumber);
        return;
      }
      _continue();
    } else if (_isEmail) {
      if (Utils.isNullOREmpty(firstName) || Utils.isNullOREmpty(lastName)) {
        Common.showSnackBar(Strings.plzEnterYourName);
        return;
      }
      if (Utils.isNullOREmpty(mobile)) {
        Common.showSnackBar(Strings.plzEnterMobileNumber);
        return;
      }
      if (Utils.isNullOREmpty(email)) {
        Common.showSnackBar(Strings.plzEnterEmail);
        return;
      }
      /*if (!Validate.isEmail(email)) {
        Common.showSnackBar(Strings.plzEnterValidEmail);
        return;
      }*/
      _signInWithUniqueID(email);
    } else if (_isPassword) {
      if (Utils.isNullOREmpty(firstName) || Utils.isNullOREmpty(lastName)) {
        Common.showSnackBar(Strings.plzEnterYourName);
        return;
      }
      if (Utils.isNullOREmpty(mobile)) {
        Common.showSnackBar(Strings.plzEnterMobileNumber);
        return;
      }
      if (Utils.isNullOREmpty(email)) {
        Common.showSnackBar(Strings.errInvalid);
        return;
      }
      /*if (!Validate.isEmail(email)) {
        Common.showSnackBar(Strings.plzEnterValidEmail);
        return;
      }*/
      if (Utils.isNullOREmpty(password)) {
        Common.showSnackBar(Strings.plzEnterPassword);
        return;
      }
      if (!Validate.isPassword(password)) {
        Common.showSnackBar(Strings.plzEnterValidPassword);
        return;
      }
      _signup(firstName, middleName, lastName, mobile, email, password);
    }
  }

  _signInWithUniqueID(String email) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    Auth? auth = await Auth.signInWithUniqueID(uniqueID: email, showErr: false);
    if (auth == null) {
      _continue();
    } else {
      Common.showSnackBar(Strings.emailAlreadyRegistered);
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  _signup(String firstName, String middleName, String lastName, String mobile,
      String email, String password) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    bool success = await Auth.signup(
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        mobile: mobile,
        email: email,
        password: password);
    if (success) {
      if (mounted) {
        Navigator.pop(context);
      }
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
        if (_isPersonalDetails) {
          _isPersonalDetails = false;
          _isEmail = true;
          _isPassword = false;

          _conEmail.clear();
          _isVerified = false;
        } else if (_isEmail) {
          _isPersonalDetails = false;
          _isEmail = false;
          _isPassword = true;

          _conPassword.clear();
          _isPasswordVisible = false;
        }
      });
    }
  }

  _back() async {
    if (!_loading) {
      if (mounted) {
        setState(() {
          if (_isPassword) {
            _isPersonalDetails = false;
            _isEmail = true;
            _isPassword = false;
          } else {
            if (_isEmail) {
              _isPersonalDetails = true;
              _isEmail = false;
              _isPassword = false;
            }
          }
        });
      }
    }
  }
}
