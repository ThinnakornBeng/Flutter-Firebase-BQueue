import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/screens/authentication.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Authentication(),
      theme: ThemeData(primarySwatch: Colors.red),
      // home: Testdart(),
    );
  }
}