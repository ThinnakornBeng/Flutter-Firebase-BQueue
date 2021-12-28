import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/screens/detailQueueForRest.dart';
import 'package:flutter_application_beng_queue_app/utility/changeData.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class ListQueueForRestaurant extends StatefulWidget {
  const ListQueueForRestaurant({Key key}) : super(key: key);

  @override
  _ListQueueForRestaurantState createState() => _ListQueueForRestaurantState();
}

class _ListQueueForRestaurantState extends State<ListQueueForRestaurant> {
  var queueModels = <QueueModel>[];
  var uidQueues = <String>[];
  var queueStatus = true;
  var statusLoad = true;
  var statusHaveData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllQueue();
    readUidQueue();
  }

  Future<void> readUidQueue() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uidRes = event.uid;
        await FirebaseFirestore.instance
            .collection('restaurantTable')
            .doc(uidRes)
            .collection('restaurantQueueTable')
            .get()
            .then((value) async {
          for (var item in value.docs) {
            String uidQueue = item.id;
            uidQueues.add(uidQueue);
          }
        });
      });
    });
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
            .orderBy('time', descending: false)
            .get()
            .then((value) {
          setState(() {
            statusLoad = false;
          });
          for (var item in value.docs) {
            QueueModel queueModel = QueueModel.fromMap(item.data());
            if (!queueModel.queueStatus) {
              setState(() {
                queueModels.add(queueModel);
                statusHaveData = true;
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
      body: statusLoad
          ? MyStyle().showProgress()
          : statusHaveData
              ? ListView.builder(
                  itemCount: queueModels.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailQueueForRrst(
                              queueModel: queueModels[index],
                              uidQueue: uidQueues[index],
                            ),
                          ));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 60,
                                height: 60,
                                child: ClipOval(
                                    child: Image.network(
                                  queueModels[index].urlImageUser,
                                  fit: BoxFit.cover,
                                ))),
                            Text(
                              ChangeData(time: queueModels[index].time)
                                  .changeTimeToString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Center(child: Text("Don't have list queue data")),
    );
  }

  Future<void> updateQueueStatus() async {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      FirebaseFirestore.instance
          .collection('restaurantTable')
          .doc(event.uid)
          .collection('restaurantQueueTable')
          .doc(event.tenantId)
          .update({"queueStatus": queueStatus}).then((value) {});
    });
  }
}
