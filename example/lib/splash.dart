import 'package:datadirr_auth/auth/auth.dart';
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
    _init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SignInScreen(
                  deviceId: "1200",
                  onSuccess: (context, token) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Dashboard(token: token)));
                  })));*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text("datadirr"))),
    );
  }

  _init() async {
    List<Auth> list = await Auth.authLinkedByDevice();
  }
}
