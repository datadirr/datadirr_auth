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
import 'package:validation_pro/validate.dart';

class ManagePassword extends StatefulWidget {
  final Function(BuildContext context)? onSignOut;

  const ManagePassword({super.key, this.onSignOut});

  @override
  State<ManagePassword> createState() => _ManagePasswordState();
}

class _ManagePasswordState extends State<ManagePassword> {
  bool _loading = false;
  Auth? _auth;
  final TextEditingController _conOldPassword = TextEditingController();
  final TextEditingController _conPassword = TextEditingController();
  final TextEditingController _conConfirmPassword = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    _auth = await Auth.currentAuth();
    if (_auth == null && widget.onSignOut != null && mounted) {
      widget.onSignOut!(context);
    }
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
              child: _loading
                  ? const CProgress()
                  : (_auth != null)
                      ? Column(
                          children: [
                            DatadirrAccountAppBar(
                                auth: _auth,
                                onBack: () {
                                  if (!_loading) {
                                    _back();
                                  }
                                }),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(Strings.password,
                                          style: Styles.txtRegular(
                                              fontSize: Fonts.fontXXLarge)),
                                      const VSpace(),
                                      Text(Strings.passwordChangesMsg,
                                          style: Styles.txtRegular(
                                              color: Colorr.grey50)),
                                      const VSpace(space: 20),
                                      CATextField(
                                        controller: _conOldPassword,
                                        hintText: Strings.enterOldPassword,
                                        obscureText: !_isPasswordVisible,
                                        suffixImage: _isPasswordVisible
                                            ? Assets.imgVisible
                                            : Assets.imgInvisible,
                                        suffixImageTap: () {
                                          if (mounted) {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          }
                                        },
                                      ),
                                      const VSpace(),
                                      CATextField(
                                        controller: _conPassword,
                                        hintText: Strings.enterPassword,
                                        obscureText: !_isPasswordVisible,
                                        suffixImage: _isPasswordVisible
                                            ? Assets.imgVisible
                                            : Assets.imgInvisible,
                                        suffixImageTap: () {
                                          if (mounted) {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          }
                                        },
                                      ),
                                      const VSpace(),
                                      CATextField(
                                        controller: _conConfirmPassword,
                                        hintText: Strings.confirmPassword,
                                        obscureText: !_isPasswordVisible,
                                        suffixImage: _isPasswordVisible
                                            ? Assets.imgVisible
                                            : Assets.imgInvisible,
                                        suffixImageTap: () {
                                          if (mounted) {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          }
                                        },
                                      ),
                                      const VSpace(),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Tap(
                                              onTap: () {},
                                              child: Text(
                                                  Strings.passwordValidMsg,
                                                  style: Styles.txtRegular(
                                                      color: Colorr.grey50,
                                                      fontSize:
                                                          Fonts.fontXSmall)))),
                                      const VSpace(space: 30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CTextButton(
                                              text: Strings.cancel,
                                              onTap: () {
                                                if (!_loading) {
                                                  _back();
                                                }
                                              },
                                              loading: _loading),
                                          const HSpace(),
                                          CButton(
                                              text: Strings.save,
                                              onTap: () {
                                                if (!_loading) {
                                                  _checkValidDetails();
                                                }
                                              },
                                              loading: _loading)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : const SignedOutUI()),
        ),
      ),
    );
  }

  _checkValidDetails() {
    String oldPassword = _conOldPassword.trimText();
    String password = _conPassword.trimText();
    String confirmPassword = _conConfirmPassword.trimText();

    if (Utils.isNullOREmpty(_auth!.authID)) {
      Common.showSnackBar(Strings.errInvalid);
      return;
    }
    if (Utils.isNullOREmpty(oldPassword)) {
      Common.showSnackBar(Strings.plzEnterOldPassword);
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

    _changePassword(oldPassword, password);
  }

  _changePassword(String oldPassword, String password) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    bool success = await Auth.changePassword(
        authID: _auth!.authID, oldPassword: oldPassword, password: password);
    if (success) {
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  _back() {
    Navigator.pop(context);
  }
}
