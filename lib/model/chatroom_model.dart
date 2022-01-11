import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String name;
  final String userProfile;
  ChatRoomModel({
     this.name,
     this.userProfile,
  });
 

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userProfile': userProfile,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      name: map['name'] ?? '',
      userProfile: map['userProfile'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomModel.fromJson(String source) => ChatRoomModel.fromMap(json.decode(source));
}
