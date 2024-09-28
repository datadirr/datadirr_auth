import 'package:datadirr_auth/auth/auth_linked_device.dart';
import 'package:datadirr_auth/auth/search_auth.dart';
import 'package:datadirr_auth/auth/sign_in.dart';
import 'package:datadirr_auth/datadirr_auth.dart';
import 'package:datadirr_auth_example/dashboard.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatadirrAuth.init(
      appID: "com.datadirr.societymanager", accessKey: "societymanager");
  await DatadirrAuth.setup(token: "ZB9iA8w9HT5gL6v6b4QPHEV2eDMwTGN3aGd4R1h6UEp6ZnZJcElEbHZKZ3pHMkdPblJiVVZtb3p0M1VqbmhQeG5wMUkxQXpiazFnVk5SaWNRMWNGdDhkakNqYkRhNU1oa0htbDBld0RNV2RDa0s5cElMTVpITzlxWFdIMDUvb0ZEV09HSThQc0h3YTQrK21O");
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
      home: SignIn(onSuccess: (context, auth) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Dashboard(auth: auth)));
      }),
    );
  }
}
