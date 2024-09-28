import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_function/function/extension.dart';
import 'package:flutter_widget_function/function/utils.dart';
import 'package:validation_pro/validate.dart';

class SearchAuth extends StatefulWidget {
  final Function(BuildContext context, Auth auth) onSuccess;

  const SearchAuth({super.key, required this.onSuccess});

  @override
  State<SearchAuth> createState() => _SearchAuthState();
}

class _SearchAuthState extends State<SearchAuth> {
  bool _loading = false;
  List<Auth> _auths = [];
  final TextEditingController _conSearch = TextEditingController();

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
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const VSpace(space: 20),
            const CImage(assetName: Assets.imgDatadirrTxt, width: 100),
            const VSpace(),
            Text(Strings.searchInDatadirr,
                textAlign: TextAlign.center, style: Styles.txtRegular()),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CATextField(
                        controller: _conSearch,
                        hintText: Strings.searchEmail,
                        radius: 30,
                        suffixImage: Assets.imgSearch,
                        suffixImageTap: () {
                          _getAuths();
                        },
                        onSubmit: (value) {
                          _getAuths();
                        },
                      ),
                    ),
                    const VSpace(),
                    Flexible(
                      child: _loading
                          ? const Progress()
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: _auths.length,
                              itemBuilder: (context, index) {
                                return _itemView(_auths[index]);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const CDivider()),
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
          widget.onSuccess(context, auth);
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
    String query = _conSearch.trimText();
    if (Utils.isNullOREmpty(query)) {
      return;
    }
    if (Validate.isEmail(query)) {
      return;
    }
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    _auths = await Auth.searchAuth(query);
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}
