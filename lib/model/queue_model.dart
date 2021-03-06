import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class QueueModel {
  final String nameRest;
  final Timestamp time;
  final String peopleAmount;
  final String tableType;
  final String nameUser;
  final String uidUser;
  final String uidRest;
  final bool queueStatus;
  final String urlImageRest;
  final String urlImageUser;
  final String address;
  QueueModel({
     this.nameRest,
     this.time,
     this.peopleAmount,
     this.tableType,
     this.nameUser,
     this.uidUser,
     this.uidRest,
     this.queueStatus,
     this.urlImageRest,
     this.urlImageUser,
     this.address,
  });
 

  Map<String, dynamic> toMap() {
    return {
      'nameRest': nameRest,
      'time': time,
      'peopleAmount': peopleAmount,
      'tableType': tableType,
      'nameUser': nameUser,
      'uidUser': uidUser,
      'uidRest': uidRest,
      'queueStatus': queueStatus,
      'urlImageRest': urlImageRest,
      'urlImageUser': urlImageUser,
      'address': address,
    };
  }

  factory QueueModel.fromMap(Map<String, dynamic> map) {
    return QueueModel(
      nameRest: map['nameRest'] ?? '',
      time: map['time'],
      peopleAmount: map['peopleAmount'] ?? '',
      tableType: map['tableType'] ?? '',
      nameUser: map['nameUser'] ?? '',
      uidUser: map['uidUser'] ?? '',
      uidRest: map['uidRest'] ?? '',
      queueStatus: map['queueStatus'] ?? false,
      urlImageRest: map['urlImageRest'] ?? '',
      urlImageUser: map['urlImageUser'] ?? '',
      address: map['address'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QueueModel.fromJson(String source) => QueueModel.fromMap(json.decode(source));
}
