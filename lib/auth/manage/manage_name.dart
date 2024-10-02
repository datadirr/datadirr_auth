import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/auth/forgot_password.dart';
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
  final Auth auth;

  const ManageName({super.key, required this.auth});

  @override
  State<ManageName> createState() => _ManageNameState();
}

class _ManageNameState extends State<ManageName> {
  bool _loading = false;
  final TextEditingController _conFirstName = TextEditingController();
  final TextEditingController _conMiddleName = TextEditingController();
  final TextEditingController _conLastName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _conFirstName.text = widget.auth.firstName;
    _conMiddleName.text = widget.auth.middleName;
    _conLastName.text = widget.auth.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return Touch(
      disable: _loading,
      child: KeyboardDismiss(
        child: Scaffold(
          backgroundColor: Colorr.white,
          body: SafeArea(
              child: Column(
            children: [
              DatadirrAccountAppBar(
                  auth: widget.auth,
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
                      children: [
                        Text(Strings.name,
                            textAlign: TextAlign.center,
                            style:
                                Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
                        const VSpace(),
                        Text(Strings.nameChangesMsg, style: Styles.txtRegular()),
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
                            message: Strings.whoCanSeeYourNameMsg,
                            icon: Assets.icPeople),
                        const VSpace(space: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
          )),
        ),
      ),
    );
  }

  _checkValidDetails() {
    String firstName = _conFirstName.trimText();
    String middleName = _conMiddleName.trimText();
    String lastName = _conLastName.trimText();

    if (Utils.isNullOREmpty(widget.auth.authID)) {
      Common.showSnackBar(Strings.errInvalid);
      return;
    }
    if (Utils.isNullOREmpty(firstName) || Utils.isNullOREmpty(lastName)) {
      Common.showSnackBar(Strings.plzEnterYourName);
      return;
    }

    _saveName(firstName, middleName, lastName);
  }

  _saveName(String firstName, String middleName, String lastName) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    bool success = await Auth.changeName(
        authID: widget.auth.authID,
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
