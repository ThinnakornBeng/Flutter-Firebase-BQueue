import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class QueueModel {
  final String nameRest;
  final String date;
  final Timestamp time;
  final String peopleAmount;
  final String tableType;
  final String nameUser;
  final String uidUser;
  final String uidRest;
  final int queueAmount;
  final bool queueStatus;
  final String tokenUser;
  final String urlImageRest;
  QueueModel({
     this.nameRest,
     this.date,
     this.time,
     this.peopleAmount,
     this.tableType,
     this.nameUser,
     this.uidUser,
     this.uidRest,
     this.queueAmount,
     this.queueStatus,
     this.tokenUser,
     this.urlImageRest,
  });
 

  Map<String, dynamic> toMap() {
    return {
      'nameRest': nameRest,
      'date': date,
      'time': time,
      'peopleAmount': peopleAmount,
      'tableType': tableType,
      'nameUser': nameUser,
      'uidUser': uidUser,
      'uidRest': uidRest,
      'queueAmount': queueAmount,
      'queueStatus': queueStatus,
      'tokenUser': tokenUser,
      'urlImageRest': urlImageRest,
    };
  }

  factory QueueModel.fromMap(Map<String, dynamic> map) {
    return QueueModel(
      nameRest: map['nameRest'] ?? '',
      date: map['date'] ?? '',
      time: map['time'],
      peopleAmount: map['peopleAmount'] ?? '',
      tableType: map['tableType'] ?? '',
      nameUser: map['nameUser'] ?? '',
      uidUser: map['uidUser'] ?? '',
      uidRest: map['uidRest'] ?? '',
      queueAmount: map['queueAmount']?.toInt() ?? 0,
      queueStatus: map['queueStatus'] ?? false,
      tokenUser: map['tokenUser'] ?? '',
      urlImageRest: map['urlImageRest'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QueueModel.fromJson(String source) => QueueModel.fromMap(json.decode(source));
}
