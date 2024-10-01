import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/auth/verification.dart';
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

class ForgotPassword extends StatefulWidget {
  final Auth auth;

  const ForgotPassword({super.key, required this.auth});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _loading = false;
  final TextEditingController _conOTP = TextEditingController();
  final TextEditingController _conPassword = TextEditingController();
  final TextEditingController _conConfirmPassword = TextEditingController();
  bool _isPasswordVisible = false;

  bool _isEmail = false;
  bool _isPassword = false;

  bool _isOTPSent = false;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _isEmail = true;
    await _sendOTP(widget.auth.email);
  }

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
                        Visibility(
                          visible: _isVerified,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FlexWidth(
                              child: CButton(
                                  text: _isPassword
                                      ? Strings.finish
                                      : Strings.next,
                                  loading: _loading,
                                  onTap: () {
                                    if (!_loading) {
                                      _checkValidDetails();
                                    }
                                  }),
                            ),
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
          Text(Strings.accountRecovery,
              textAlign: TextAlign.center,
              style: Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
          const VSpace(space: 5),
          Text(Strings.accountRecoveryMsg,
              textAlign: TextAlign.center, style: Styles.txtRegular()),
          const VSpace(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileUI(
                  value: widget.auth.name, size: 25, fontSize: Fonts.fontSmall),
              const HSpace(),
              Flexible(
                child: Text(widget.auth.email,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.txtRegular(color: Colorr.primaryBlue)),
              ),
            ],
          ),
          const VSpace(space: 30),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: _isOTPSent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VSpace(),
                    CATextField(
                      controller: _conOTP,
                      hintText: Strings.otp,
                      inputType: TextInputType.number,
                      inputFormatters: [Validate.intValueFormatter()],
                      suffixImage: Assets.imgVerify,
                      suffixImageTap: () {
                        if (!_loading) {
                          _checkValidDetailsOTP();
                        }
                      },
                    ),
                    const VSpace(),
                    Text(
                      Strings.plzCheckMailMsg,
                      style: Styles.txtRegular(
                          color: Colorr.grey50, fontSize: Fonts.fontXSmall),
                    )
                  ],
                ),
              ),
              const VSpace(space: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Tap(
                      onTap: () {
                        if (!_loading) {
                          _checkValidDetailsOTP(send: true);
                        }
                      },
                      child: Text(
                          _isOTPSent ? Strings.resendIt : Strings.verify,
                          style: Styles.txtMedium(color: Colorr.primaryBlue)))),
            ],
          ),
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
            hintText: Strings.enterPassword,
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
          CATextField(
            controller: _conConfirmPassword,
            hintText: Strings.confirmPassword,
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

  _checkValidDetailsOTP({bool send = false}) async {
    String email = widget.auth.email;
    String otp = _conOTP.trimText();
    if (Utils.isNullOREmpty(email)) {
      Common.showSnackBar(Strings.plzEnterEmail);
      return;
    }
    if (!Validate.isEmail(email)) {
      Common.showSnackBar(Strings.plzEnterValidEmail);
      return;
    }

    if (_isOTPSent && !send) {
      if (Utils.isNullOREmpty(otp)) {
        Common.showSnackBar(Strings.plzEnterOTP);
        return;
      }

      _verifyOTP(email, otp);
    } else {
      _sendOTP(email);
    }
  }

  _sendOTP(email) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    bool success = await Verification.sendOTPToEmail(email: email);
    if (success) {
      _isOTPSent = true;
    } else {
      _isOTPSent = false;
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  _verifyOTP(email, otp) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    bool success = await Verification.verifyOTPByEmail(email: email, otp: otp);
    if (success) {
      _isVerified = true;
      _continue();
    } else {
      _isVerified = false;
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  _checkValidDetails() {
    String email = widget.auth.email;
    String password = _conPassword.trimText();
    String confirmPassword = _conConfirmPassword.trimText();
    if (_isEmail) {
      if (_isVerified) {
        if (Utils.isNullOREmpty(email)) {
          Common.showSnackBar(Strings.plzEnterEmail);
          return;
        }
        if (!Validate.isEmail(email)) {
          Common.showSnackBar(Strings.plzEnterValidEmail);
          return;
        }
        _continue();
      } else {
        Common.showSnackBar(Strings.plzVerifyYourEmail);
        return;
      }
    } else if (_isPassword) {
      if (Utils.isNullOREmpty(email)) {
        Common.showSnackBar(Strings.plzEnterValidEmail);
        return;
      }
      if (!Validate.isEmail(email)) {
        Common.showSnackBar(Strings.plzEnterValidEmail);
        return;
      }
      if (Utils.isNullOREmpty(password)) {
        Common.showSnackBar(Strings.plzEnterPassword);
        return;
      }
      if (!Validate.isPassword(password)) {
        Common.showSnackBar(Strings.plzEnterValidPassword);
        return;
      }
      if (Utils.isNullOREmpty(confirmPassword)) {
        Common.showSnackBar(Strings.plzEnterConfirmPassword);
        return;
      }
      if (!Utils.equals(password, confirmPassword, ignoreCase: false)) {
        Common.showSnackBar(Strings.passwordDoesNotMatch);
        return;
      }
      _resetPassword(email, password);
    }
  }

  _resetPassword(String email, String password) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    bool success = await Auth.resetPassword(email: email, password: password);
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
      Navigator.pop(context);
    }
  }
}
