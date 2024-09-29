import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/auth/sign_in.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:flutter/material.dart';

class DatadirrSignIn extends StatefulWidget {
  final Function(BuildContext context, Auth auth) onSuccess;

  const DatadirrSignIn({super.key, required this.onSuccess});

  @override
  State<DatadirrSignIn> createState() => _DatadirrSignInState();
}

class _DatadirrSignInState extends State<DatadirrSignIn> {
  bool _loading = false;
  List<Auth> _auths = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    await _getAuths();
  }

  @override
  Widget build(BuildContext context) {
    return Touch(
      disable: _loading,
      child: Scaffold(
        backgroundColor: Colorr.white,
        body: SafeArea(
            child: (_loading || _auths.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Assets.icSystemUpdate,
                            color: Colorr.primary),
                        const VSpace(),
                        Text(Strings.checkingInfo,
                            textAlign: TextAlign.center,
                            style:
                                Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
                        const VSpace(space: 30),
                        const CProgress(size: 150),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const VSpace(space: 20),
                      const CImage(Assets.imgDatadirrTxt, width: 100),
                      const VSpace(),
                      Text(Strings.signInWithYourDatadirrAccount,
                          textAlign: TextAlign.center,
                          style: Styles.txtRegular()),
                      const VSpace(space: 30),
                      Flexible(
                        child: Container(
                          decoration: Styles.boxDecoration(
                              radius: 30,
                              color: Colorr.white,
                              blur: 10,
                              blurColor: Colorr.grey20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const VSpace(),
                              Flexible(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: _auths.length,
                                    itemBuilder: (context, index) {
                                      return _itemView(_auths[index]);
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const CDivider()),
                              ),
                              const CDivider(),
                              Tap(
                                onTap: () {
                                  _gotoSignIn(back: true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        padding: const EdgeInsets.all(5),
                                        child: const Center(
                                          child: Icon(Assets.icAddAccount,
                                              color: Colorr.primary),
                                        ),
                                      ),
                                      const HSpace(),
                                      Expanded(
                                          child: Text(Strings.addAnotherAccount,
                                              overflow: TextOverflow.ellipsis,
                                              style: Styles.txtMedium()))
                                    ],
                                  ),
                                ),
                              ),
                              const CDivider(),
                              Tap(
                                onTap: () {
                                  if (!_loading) {
                                    _signOutAll();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        padding: const EdgeInsets.all(5),
                                        child: const Center(
                                          child: Icon(Assets.icSignOut,
                                              color: Colorr.primary),
                                        ),
                                      ),
                                      const HSpace(),
                                      Expanded(
                                          child: Text(
                                              Strings.signOutAllAccounts,
                                              overflow: TextOverflow.ellipsis,
                                              style: Styles.txtMedium()))
                                    ],
                                  ),
                                ),
                              ),
                              const VSpace(),
                            ],
                          ),
                        ),
                      )
                    ]),
                  )),
      ),
    );
  }

  _itemView(Auth auth) {
    return Tap(
      onTap: () {
        if (!_loading) {
          _success(auth);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: ProfileUI(
                value: auth.name,
                size: 40,
                radius: 30,
              ),
            ),
            const HSpace(),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(auth.name,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.txtMedium()),
                  Text(
                    auth.email,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.txtRegular(
                        color: Colorr.grey50, fontSize: Fonts.fontSmall),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _getAuths() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    _auths = await Auth.authLinkedByDevice();
    if (_auths.isEmpty) {
      _gotoSignIn();
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  _signOutAll() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    bool success = await Auth.signOutAll();
    if (success) {
      _getAuths();
    } else {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  _gotoSignIn({bool back = false}) {
    if (back) {
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => const SignIn()))
          .then((value) async {
        Auth? auth = value;
        if (auth != null) {
          _success(auth);
        }
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SignIn(onSuccess: widget.onSuccess)),
          (route) => false);
    }
  }

  _success(Auth? auth) async {
    if (auth != null) {
      await Auth.setCurrentAuth(auth);
      if (mounted) {
        widget.onSuccess(context, auth);
      }
    }
  }
}
