import 'package:datadirr_auth/auth/auth_linked_device.dart';
import 'package:datadirr_auth/datadirr_auth.dart';
import 'package:datadirr_auth_example/Splash.dart';
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthLinkedDevice(),
    );
  }
}
