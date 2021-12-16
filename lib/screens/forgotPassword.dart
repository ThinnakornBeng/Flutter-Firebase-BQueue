import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/utility/dialog.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 250,
              child: TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
              onPressed: () => processForgot(),
              child: Text('Sent'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> processForgot() async {
    Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text)
          .then(
            (value) => normalDialog(
                context, 'GO to your Email Address resrt password'),
          )
          .catchError((error) {
        normalDialog(context, error.message);
      });
    });
  }
}
