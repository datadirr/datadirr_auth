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
  final Function(BuildContext context)? onSignOut;

  const ManageBirthdate({super.key, this.onSignOut});

  @override
  State<ManageBirthdate> createState() => _ManageBirthdateState();
}

class _ManageBirthdateState extends State<ManageBirthdate> {
  bool _loading = false;
  bool _loadingSubmit = false;
  Auth? _auth;
  String _birthdate = "";

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
      _birthdate = _auth!.birthdate;
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
      disable: (_loading || _loadingSubmit),
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
                                  if (!_loading && !_loadingSubmit) {
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
                                      Text(Strings.birthdate,
                                          style: Styles.txtRegular(
                                              fontSize: Fonts.fontXXLarge)),
                                      const VSpace(),
                                      Text(Strings.birthdateChangesMsg,
                                          style: Styles.txtRegular(
                                              color: Colorr.grey50)),
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
                                                maxDate:
                                                    DateTimes.getCurrentDate());
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CTextButton(
                                              text: Strings.cancel,
                                              onTap: () {
                                                if (!_loading &&
                                                    !_loadingSubmit) {
                                                  _back();
                                                }
                                              },
                                              loading: _loadingSubmit),
                                          const HSpace(),
                                          CButton(
                                              text: Strings.save,
                                              onTap: () {
                                                if (!_loading &&
                                                    !_loadingSubmit) {
                                                  _checkValidDetails();
                                                }
                                              },
                                              loading: _loadingSubmit)
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
    if (Utils.isNullOREmpty(_auth!.authID)) {
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
        _loadingSubmit = true;
      });
    }
    bool success = await Auth.changeBirthdate(
        authID: _auth!.authID, birthdate: _birthdate);
    if (success) {
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
    if (mounted) {
      setState(() {
        _loadingSubmit = false;
      });
    }
  }

  _back() {
    Navigator.pop(context);
  }
}
