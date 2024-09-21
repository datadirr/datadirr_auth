import 'package:datadirr_auth/auth/sign_in_screen.dart';
import 'package:datadirr_auth/datadirr_auth.dart';
import 'package:datadirr_auth_example/dashboard.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatadirrAuth.init(
      appID: "com.datadirr.societymanager", accessKey: "societymanager");
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
      home: SignInScreen(
        deviceId: "1200",
        onSuccess: (context, token) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Dashboard(token: token)));
        },
      ),
    );
  }
}
