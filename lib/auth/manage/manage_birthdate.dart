import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:date_time_plus/date_times.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_function/function/utils.dart';
import 'package:flutter_widget_function/widget/keyboard/keyboard_dismiss.dart';

class ManageBirthdate extends StatefulWidget {
  final Auth auth;

  const ManageBirthdate({super.key, required this.auth});

  @override
  State<ManageBirthdate> createState() => _ManageBirthdateState();
}

class _ManageBirthdateState extends State<ManageBirthdate> {
  bool _loading = false;
  String _birthdate = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _birthdate = widget.auth.birthdate;
    if (mounted) {
      setState(() {});
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(Strings.birthdate,
                            style:
                                Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
                        const VSpace(),
                        Text(Strings.birthdateChangesMsg,
                            style: Styles.txtRegular()),
                        const VSpace(space: 20),
                        CAText(
                            onTap: () {
                              DateTimes.datePicker(
                                  context: context,
                                  date: _birthdate,
                                  onSelected: (date) {
                                    _birthdate = date;
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                  maxDate: DateTimes.getCurrentDate());
                            },
                            text: DateTimes.formatDateTime(
                                dateTime: _birthdate,
                                inFormat: Format.fyyyyMMdd,
                                outFormat: Format.fddMMMyyyy),
                            hintText: Strings.birthdate),
                        const VSpace(space: 30),
                        const InfoUI(
                            title: Strings.whoCanSeeYourBirthdate,
                            message: Strings.whoCanSeeYourInfoMsg,
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
    if (Utils.isNullOREmpty(widget.auth.authID)) {
      Common.showSnackBar(Strings.errInvalid);
      return;
    }
    if (Utils.isNullOREmpty(_birthdate)) {
      Common.showSnackBar(Strings.plzSelectYourBirthdate);
      return;
    }

    _changeBirthdate();
  }

  _changeBirthdate() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    bool success = await Auth.changeBirthdate(
        authID: widget.auth.authID, birthdate: _birthdate);
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
