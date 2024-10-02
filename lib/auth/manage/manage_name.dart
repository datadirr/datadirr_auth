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

class ManageName extends StatefulWidget {
  final Function(BuildContext context)? onSignOut;

  const ManageName({super.key, this.onSignOut});

  @override
  State<ManageName> createState() => _ManageNameState();
}

class _ManageNameState extends State<ManageName> {
  bool _loading = false;
  Auth? _auth;
  final TextEditingController _conFirstName = TextEditingController();
  final TextEditingController _conMiddleName = TextEditingController();
  final TextEditingController _conLastName = TextEditingController();

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
    } else {
      _conFirstName.text = _auth!.firstName;
      _conMiddleName.text = _auth!.middleName;
      _conLastName.text = _auth!.lastName;
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
                                      Text(Strings.name,
                                          style: Styles.txtRegular(
                                              fontSize: Fonts.fontXXLarge)),
                                      const VSpace(),
                                      Text(Strings.nameChangesMsg,
                                          style: Styles.txtRegular(
                                              color: Colorr.grey50)),
                                      const VSpace(space: 20),
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
                                      const VSpace(space: 30),
                                      const InfoUI(
                                          title: Strings.whoCanSeeYourName,
                                          message: Strings.whoCanSeeYourInfoMsg,
                                          icon: Assets.icPeople),
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
    String firstName = _conFirstName.trimText();
    String middleName = _conMiddleName.trimText();
    String lastName = _conLastName.trimText();

    if (Utils.isNullOREmpty(_auth!.authID)) {
      Common.showSnackBar(Strings.errInvalid);
      return;
    }
    if (Utils.isNullOREmpty(firstName) || Utils.isNullOREmpty(lastName)) {
      Common.showSnackBar(Strings.plzEnterYourName);
      return;
    }

    _changeName(firstName, middleName, lastName);
  }

  _changeName(String firstName, String middleName, String lastName) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    bool success = await Auth.changeName(
        authID: _auth!.authID,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName);
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
