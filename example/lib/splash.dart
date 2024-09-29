import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/auth/datadirr_sign_in.dart';
import 'package:datadirr_auth_example/dashboard.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text("datadirr"))),
    );
  }

  _init() async {
    Auth? auth = await Auth.currentAuth();
    if (mounted) {
      if (auth != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Dashboard(auth: auth)),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => DatadirrSignIn(
                    onSuccess: (context, auth) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Dashboard(auth: auth)),
                        (route) => false))),
            (route) => false);
      }
    }
  }
}
