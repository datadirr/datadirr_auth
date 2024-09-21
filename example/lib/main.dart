import 'package:datadirr_auth/auth/sign_in_screen.dart';
import 'package:datadirr_auth_example/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignInScreen(onSuccess: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Dashboard()));
        }));
  }
}
