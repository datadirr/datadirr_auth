import 'package:datadirr_auth/auth/auth.dart';
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
      body: SafeArea(child: Text(widget.auth.email)),
    );
  }
}
