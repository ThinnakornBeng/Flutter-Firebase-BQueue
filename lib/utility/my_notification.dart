import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MyNotification {
  BuildContext context;
  MyNotification({@required BuildContext context});
  Future<void> forNotification() async {
    // for FonEnd Service
    FirebaseMessaging.onMessage.listen((event) {
      String titleNoti = event.notification.title;
      String bodyNoti = event.notification.body;
      print(
          'Form Fontend User titleNoti == $titleNoti, bodeyNoti == $bodyNoti');
    });

    // for BlackEnd Service
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      String titleNoti = event.notification.title;
      String bodyNoti = event.notification.body;
      print(
          'form BlackEnd User titleNoti == $titleNoti, bodeyNoti == $bodyNoti');
    });
  }
}
