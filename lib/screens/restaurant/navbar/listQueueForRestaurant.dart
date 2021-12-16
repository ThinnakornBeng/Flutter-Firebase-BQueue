import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/utility/changeData.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';

class ListQueueForRestaurant extends StatefulWidget {
  const ListQueueForRestaurant({Key key}) : super(key: key);

  @override
  _ListQueueForRestaurantState createState() => _ListQueueForRestaurantState();
}

class _ListQueueForRestaurantState extends State<ListQueueForRestaurant> {
  var queueModels = <QueueModel>[];

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
              itemBuilder: (context, index) => Text(
                  ChangeData(time: queueModels[index].time)
                      .changeTimeToString()),
            ),
    );
  }
}
