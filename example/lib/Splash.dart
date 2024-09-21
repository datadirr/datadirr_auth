import 'package:datadirr_auth/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final String token;
  const Dashboard({super.key, required this.token});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text(widget.token)),
    );
  }
}
