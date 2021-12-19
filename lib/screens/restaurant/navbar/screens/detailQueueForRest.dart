import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';

class DetailQueueForRrst extends StatefulWidget {
  final QueueModel queueModel;
  final String uidQueue;
  const DetailQueueForRrst(
      {Key key, @required this.queueModel, @required this.uidQueue})
      : super(key: key);

  @override
  _DetailQueueForRrstState createState() => _DetailQueueForRrstState();
}

class _DetailQueueForRrstState extends State<DetailQueueForRrst> {
  QueueModel queueModel;
  var uidQueue;
  var queueStatus = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queueModel = widget.queueModel;
    uidQueue = widget.uidQueue;
    readUidQueue();
    print('UidQueue ==>> $uidQueue');
  }

  Future<void> readUidQueue() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uidRes = event.uid;
        await FirebaseFirestore.instance
            .collection('restaurantTable')
            .doc(uidRes)
            .get()
            .then((value) async {
          String queueUid = value.id;
          await FirebaseAuth.instance.authStateChanges().listen((event) async {
            await FirebaseFirestore.instance
                .collection('restaurantQueueTable')
                .doc(event.uid)
                .get()
                .then((value) {});
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ElevatedButton(
              onPressed: () async {
                updateQueueStatus();
                String uidUser = queueModel.uidUser;
                // print('You click $uidUser');
                await Firebase.initializeApp().then((value) async {
                  await FirebaseFirestore.instance
                      .collection('userTable')
                      .doc(uidUser)
                      .get()
                      .then((value) async {
                    UserModel userModel = UserModel.fromMap(value.data());
                    String token = userModel.token;
                    // print('Token Is ====>>>> $token');

                    var title = 'คุณ ${queueModel.nameUser} ';
                    var body = 'ถึงคิวของคุณแล้วกรุณาไปใช้บริการภายใน 10 นาที';

                    var path =
                        'https://www.androidthai.in.th/mea/bengapiNotification.php?isAdd=true&token=$token&title=$title&body=$body';

                    await Dio().get(path).then((value) {
                      print('Value ===>>> $value');
                    });
                  });
                });
              },
              child: Text('SenNoti'))),
    );
  }

  Future<void> updateQueueStatus() async {
    Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection('restaurantTable')
          .doc(queueModel.uidRest)
          .collection('restaurantQueueTable')
          .doc(uidQueue)
          .update({"queueStatus": queueStatus}).then((value) {});
    });
  }
}
