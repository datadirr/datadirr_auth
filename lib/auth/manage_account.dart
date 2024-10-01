import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:flutter/material.dart';

class ManageAccount extends StatefulWidget {
  final Auth auth;

  const ManageAccount({super.key, required this.auth});

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Touch(
      disable: _loading,
      child: Scaffold(
        backgroundColor: Colorr.white,
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const VSpace(space: 30),
                  ProfileUI(
                      value: widget.auth.name,
                      size: 80,
                      radius: 50,
                      fontSize: Fonts.fontXXXLarge),
                  const VSpace(),
                  Text(widget.auth.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.txtMedium(fontSize: Fonts.fontXXLarge)),
                  Text(widget.auth.email,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.txtRegular()),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CDivider(),
                        const VSpace(),
                        Text(Strings.basicInfo,
                            overflow: TextOverflow.ellipsis, style: Styles.txtMedium()),
                        const VSpace(space: 15),
                        _itemRow(
                            title: Strings.name.toUpperCase(),
                            value: widget.auth.fullName),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  _itemRow({required String title, required String value, Function()? onTap}) {
    return Tap(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.txtRegular(
                        color: Colorr.grey50, fontSize: Fonts.fontXSmall)),
                Text(value, style: Styles.txtRegular()),
              ],
            ),
          ),
          const Icon(Assets.icArrowForward, size: 20)
        ],
      ),
    );
  }
}
