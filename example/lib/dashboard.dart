import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/auth/datadirr_sign_in.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final Auth auth;

  const Dashboard({super.key, required this.auth});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ElevatedButton(
              onPressed: () {
                _manageSignIn();
              },
              child: Text(widget.auth.firstName))),
    );
  }

  _manageSignIn() async {
    if (mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DatadirrSignIn(
                auth: widget.auth,
                  onSuccess: (context, auth) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Dashboard(auth: auth)),
                      (route) => false))));
    }
  }
}
