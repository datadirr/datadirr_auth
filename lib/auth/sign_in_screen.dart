import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/plugin.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_function/widget/responsive/responsive_layout.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _conEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colorr.primary,
            primary: Colorr.primary,
            surface: Colorr.white),
        scaffoldBackgroundColor: Colorr.white,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                const VSpace(space: 20),
                Image.asset(Assets.imgDatadirrTxt,
                    width: 100, package: Plugin.package),
                const VSpace(space: 20),
                Text(Strings.signIn,
                    style: Styles.txtRegular(fontSize: Fonts.fontXXLarge)),
                const VSpace(),
                Text(Strings.signInMsg, style: Styles.txtRegular()),
                const VSpace(space: 30),
                CATextField(
                  controller: _conEmail,
                  hintText: Strings.email,
                ),
                const VSpace(space: 30),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Tap(
                        onTap: () {},
                        child: Text(Strings.createAccount,
                            style: Styles.txtRegular(color: Colorr.primaryBlue))))
              ]),
              Align(
                alignment: Alignment.centerRight,
                child: FlexWidth(
                  child: CButton(text: Strings.next, onTap: () {}),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
