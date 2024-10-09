import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/data/country/country.dart';
import 'package:datadirr_auth/data/country/country_selection.dart';
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

class ManageMobile extends StatefulWidget {
  final Function(BuildContext context)? onSignOut;

  const ManageMobile({super.key, this.onSignOut});

  @override
  State<ManageMobile> createState() => _ManageMobileState();
}

class _ManageMobileState extends State<ManageMobile> {
  bool _loading = false;
  bool _loadingSubmit = false;
  Auth? _auth;
  final TextEditingController _conMobile = TextEditingController();
  Country? _country;

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
      _country = !Utils.isNullOREmpty(_auth!.countryIdForMobile)
          ? Country(
              countryId: _auth!.countryIdForMobile,
              countryPhoneCodePlus: _auth!.countryPhoneCodePlus)
          : null;
      _conMobile.text = _auth!.mobile;
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
                                      Text(Strings.mobileNumber,
                                          style: Styles.txtRegular(
                                              fontSize: Fonts.fontXXLarge)),
                                      const VSpace(),
                                      Text(Strings.mobileChangesMsg,
                                          style: Styles.txtRegular(
                                              color: Colorr.grey50)),
                                      const VSpace(space: 20),
                                      Row(
                                        children: [
                                          FlexWidth(
                                            child: CAText(
                                                text: (_country != null)
                                                    ? _country!
                                                        .countryPhoneCodePlus
                                                    : "-",
                                                onTap: () {
                                                  if (!_loading &&
                                                      !_loadingSubmit) {
                                                    _gotoCountrySelection();
                                                  }
                                                }),
                                          ),
                                          const HSpace(),
                                          Expanded(
                                            child: CATextField(
                                              controller: _conMobile,
                                              hintText: Strings.mobileNumber,
                                              inputType: TextInputType.number,
                                              inputFormatters: [
                                                Validate.intValueFormatter()
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VSpace(space: 30),
                                      const InfoUI(
                                          title:
                                              Strings.whoCanSeeYourMobileNumber,
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

  _gotoCountrySelection() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CountrySelection(country: _country)))
        .then((value) {
      Country? country = value;
      if (country != null) {
        _country = country;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  _checkValidDetails() {
    String mobile = _conMobile.trimText();
    if (Utils.isNullOREmpty(_auth!.authID)) {
      Common.showSnackBar(Strings.errInvalid);
      return;
    }
    if (_country == null) {
      Common.showSnackBar(Strings.plzSelectCountryForMobileNumber);
      return;
    }
    if (Utils.isNullOREmpty(mobile)) {
      Common.showSnackBar(Strings.plzEnterMobileNumber);
      return;
    }

    _changeMobile(mobile);
  }

  _changeMobile(String mobile) async {
    if (mounted) {
      setState(() {
        _loadingSubmit = true;
      });
    }
    bool success = await Auth.changeMobile(
        authID: _auth!.authID,
        countryIdForMobile: _country!.countryId,
        mobile: mobile);
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
