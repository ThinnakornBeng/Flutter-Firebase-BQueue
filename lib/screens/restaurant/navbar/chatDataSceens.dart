import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/chatroom_model.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/screens/chatRestaurant.dart';

class ChatSceens extends StatefulWidget {
  const ChatSceens({Key key}) : super(key: key);

  @override
  _ChatSceensState createState() => _ChatSceensState();
}

class _ChatSceensState extends State<ChatSceens> {
  List<Map<String, dynamic>> chatRoomMap;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ChatRoomModel> chatRoomModels = [];
  String chatRoomId;
  RestaurantModel restaurantModel;
  String uidUser;
  UserModel userModel;


  Future<void> readChatRoomData() async {
    Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        chatRoomId = event.uid;
        await _firestore.collection('chatroom').snapshots().listen(
          (value) async {
            for (var item in value.docs) {
              ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(item.data());
              setState(() {
                chatRoomModels.add(chatRoomModel);
              });
            }
            // print(chatRoomModels);
          },
        );
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readChatRoomData();
    readDataLoginAndDatarestaurant();
  }

  Future<Void> readDataLoginAndDatarestaurant() async {
    await Firebase.initializeApp().then(
      (value) async {
        await FirebaseAuth.instance.authStateChanges().listen(
          (event) async {
            uidUser = event.uid;
            // print('Uid = $uidUser');
            await FirebaseFirestore.instance
                .collection('userTable')
                .doc(uidUser)
                .snapshots()
                .listen(
              (event) {
                setState(
                  () {
                    userModel = UserModel.fromMap(event.data());
                    String nameLogin = userModel.name;
                    // print('NameLogin ====>>>> $nameLogin');
                  },
                );
              },
            );
            await FirebaseFirestore.instance
                .collection('restaurantTable')
                .doc(uidUser)
                .snapshots()
                .listen(
              (event) async {
                setState(() {
                  restaurantModel = RestaurantModel.fromMap(event.data());
                });
                // print(restaurantModel);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView.builder(
        itemCount: chatRoomModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatroomRestaurant(
                    chatRoomId: chatRoomId,
                    restaurantModel: restaurantModel,chatRoomModel: chatRoomModels[index],
                  ),
                ));
          },
          child: Card(
              child: Row(
            children: [
              Image.network(chatRoomModels[index].userProfile),
              Text(chatRoomModels[index].name),
            ],
          )),
        ),
      ),
    ));
  }
}
