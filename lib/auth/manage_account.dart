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
            child: Center(
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
              const VSpace(),
                        ],
                      ),
            )),
      ),
    );
  }
  
  _itemRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(Strings.birthdate)
            ],
          ),
        ),Icon(Assets.icArrowForward)
      ],
    );
  }
}
