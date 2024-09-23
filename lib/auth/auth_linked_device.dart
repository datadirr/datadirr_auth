import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:flutter/material.dart';

class AuthLinkedDevice extends StatefulWidget {
  const AuthLinkedDevice({super.key});

  @override
  State<AuthLinkedDevice> createState() => _AuthLinkedDeviceState();
}

class _AuthLinkedDeviceState extends State<AuthLinkedDevice> {
  List<Auth> _auths = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _auths = await Auth.authLinkedByDevice();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorr.grey10,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const VSpace(space: 20),
          const CImage(assetName: Assets.imgDatadirrTxt, width: 100),
          const VSpace(),
          Text(Strings.signInAuthMsg,
              textAlign: TextAlign.center, style: Styles.txtRegular()),
          const VSpace(space: 30),
          Flexible(
            child: Container(
              decoration: Styles.boxDecoration(radius: 30, color: Colorr.white),
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
                        separatorBuilder: (BuildContext context, int index) =>
                            const CDivider()),
                  ),
                  const CDivider(),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          decoration: Styles.boxDecoration(
                              color: Colorr.blue10, radius: 20),
                          child: const Center(
                            child: Icon(Assets.icAdd, color: Colorr.primary),
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
                  const CDivider(),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          child: const Center(
                            child: Icon(Assets.icSignOut, color: Colorr.primary),
                          ),
                        ),
                        const HSpace(),
                        Expanded(
                            child: Text(Strings.signOutAllAccounts,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.txtMedium()))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      )),
    );
  }

  _itemView(Auth auth) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: ProfileUI(
              value: auth.firstName,
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
                Text("${auth.firstName} ${auth.lastName}",
                    overflow: TextOverflow.ellipsis, style: Styles.txtMedium()),
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
    );
  }
}
