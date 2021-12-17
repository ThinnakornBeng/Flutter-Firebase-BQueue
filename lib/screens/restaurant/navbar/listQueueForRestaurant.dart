import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/utility/changeData.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class ListQueueForRestaurant extends StatefulWidget {
  const ListQueueForRestaurant({Key key}) : super(key: key);

  @override
  _ListQueueForRestaurantState createState() => _ListQueueForRestaurantState();
}

class _ListQueueForRestaurantState extends State<ListQueueForRestaurant> {
  var queueModels = <QueueModel>[];
  bool queueStatus = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllQueue();
  }

  Future<Null> readAllQueue() async {
    if (queueModels.isEmpty) {
      queueModels.clear();
    }
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        await FirebaseFirestore.instance
            .collection('restaurantTable')
            .doc(event.uid)
            .collection('restaurantQueueTable')
            .orderBy('time', descending: true)
            .get()
            .then((value) {
          for (var item in value.docs) {
            QueueModel queueModel = QueueModel.fromMap(item.data());
            if (!queueModel.queueStatus) {
              setState(() {
                queueModels.add(queueModel);
              });
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: queueModels.isEmpty
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: queueModels.length,
              itemBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ChangeData(time: queueModels[index].time)
                            .changeTimeToString(),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            updateQueueStatus();
                            String uidUser = queueModels[index].uidUser;
                            // print('You click $uidUser');

                            await Firebase.initializeApp().then((value) async {
                              await FirebaseFirestore.instance
                                  .collection('userTable')
                                  .doc(uidUser)
                                  .get()
                                  .then((value) async {
                                UserModel userModel =
                                    UserModel.fromMap(value.data());
                                String token = userModel.token;
                                // print('Token Is ====>>>> $token');

                                var title =
                                    'คุณ ${queueModels[index].nameUser} ';
                                var body =
                                    'ถึงคิวของคุณแล้วกรุณาไปใช้บริการภายใน 10 นาที';

                                var path =
                                    'https://www.androidthai.in.th/mea/bengapiNotification.php?isAdd=true&token=$token&title=$title&body=$body';

                                await Dio().get(path).then((value) {
                                  print('Value ===>>> $value');
                                });
                              });
                            });
                          },
                          child: Text('SenNoti'))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> updateQueueStatus() async {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      FirebaseFirestore.instance.collection('restaurantQueueTable')
        .doc(event.uid).update({"queueStatus": queueStatus}).then((value) {});
    });
  }
}
