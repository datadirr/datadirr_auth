import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/data/gender/gender.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_plus/dropdown_item.dart';
import 'package:flutter_widget_function/function/utils.dart';
import 'package:flutter_widget_function/widget/keyboard/keyboard_dismiss.dart';

class ManageGender extends StatefulWidget {
  final Function(BuildContext context)? onSignOut;

  const ManageGender({super.key, this.onSignOut});

  @override
  State<ManageGender> createState() => _ManageGenderState();
}

class _ManageGenderState extends State<ManageGender> {
  bool _loading = false;
  Auth? _auth;
  List<DropdownItem> _genderList = [];
  String _genderId = "";

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
      _genderId = _auth!.genderId;
      _getGender();
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
                                      Text(Strings.gender,
                                          style: Styles.txtRegular(
                                              fontSize: Fonts.fontXXLarge)),
                                      const VSpace(),
                                      Text(Strings.genderChangesMsg,
                                          style: Styles.txtRegular(
                                              color: Colorr.grey50)),
                                      const VSpace(space: 20),
                                      CADropdown(
                                          hintText: Strings.gender,
                                          selectedId: _genderId,
                                          list: _genderList,
                                          onSelected: (id) {
                                            _genderId = id;
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          }),
                                      const VSpace(space: 30),
                                      const InfoUI(
                                          title: Strings.whoCanSeeYourGender,
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

  _getGender() async {
    _genderList = await Gender.dropdownGender();
    if (mounted) {
      setState(() {});
    }
  }

  _checkValidDetails() {
    if (Utils.isNullOREmpty(_auth!.authID)) {
      Common.showSnackBar(Strings.errInvalid);
      return;
    }
    if (Utils.isNullOREmpty(_genderId)) {
      Common.showSnackBar(Strings.plzSelectYourGender);
      return;
    }

    _changeGender();
  }

  _changeGender() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    bool success =
        await Auth.changeGender(authID: _auth!.authID, genderId: _genderId);
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
