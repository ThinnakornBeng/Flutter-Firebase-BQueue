import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/chatroom_model.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';

class ChatroomRestaurant extends StatefulWidget {
  final String chatRoomId;
  final RestaurantModel restaurantModel;
  final ChatRoomModel chatRoomModel;
  const ChatroomRestaurant(
      {Key key,
      @required this.chatRoomId,
      @required this.restaurantModel,
      @required this.chatRoomModel})
      : super(key: key);

  @override
  _ChatroomRestaurantState createState() => _ChatroomRestaurantState();
}

class _ChatroomRestaurantState extends State<ChatroomRestaurant> {
  TextEditingController msg = new TextEditingController();
  String chatRoomId;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RestaurantModel restaurantModel;
  ChatRoomModel chatRoomModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatRoomId = widget.chatRoomId;
    restaurantModel = widget.restaurantModel;
    chatRoomModel = widget.chatRoomModel;
  }

  void onSentMessage() async {
    if (msg.text.isNotEmpty) {
      Map<String, dynamic> message = {
        'sendby': restaurantModel.nameRes,
        'message': msg.text,
        'time': FieldValue.serverTimestamp(),
        // 'uidRest': queueModel.uidRest,
      };

      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chat')
          .add(message);
      msg.clear();
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('คุณ ${chatRoomModel.name}'),
      ),
      body: Container(
        height: size.height / 1.25,
        width: size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('chatroom')
              .doc(chatRoomId)
              .collection('chat')
              .orderBy('time', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> map = snapshot.data.docs[index].data();
                  return message(size, map);
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: size.height / 8,
        width: size.height,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: size.height / 10,
            width: size.height,
            child: TextField(
              controller: msg,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      onSentMessage();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.red,
                    )),
                hintText: 'Enter Message...',
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ),

      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(6.0),
      //       child: Text('Message'),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Container(
      //         child: TextField(
      //           controller: msg,
      //           decoration: InputDecoration(
      //             hintText: 'Enter Message...',
      //             suffixIcon: IconButton(
      //               onPressed: () {
      //                 print(msg.text);
      //                 msg.clear();
      //               },
      //               icon: Icon(
      //                 Icons.send,
      //                 color: Colors.red,
      //               ),
      //             ),
      //             border: InputBorder.none,
      //             enabledBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(10),
      //               borderSide: BorderSide(color: Colors.red),
      //             ),
      //             focusedBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(10),
      //               borderSide: BorderSide(color: Colors.red),
      //             ),
      //           ),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }

  Widget message(Size size, Map<String, dynamic> map) {
    return Container(
      width: size.width,
      alignment: map['sendby'] == restaurantModel.nameRes
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          map['message'],
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
