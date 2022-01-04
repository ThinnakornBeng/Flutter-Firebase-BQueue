import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/queue_model.dart';
import 'package:intl/intl.dart';

class DetailForRestaurantSuccess extends StatefulWidget {
  final QueueModel queueModel;
  final String uidQueue;
  const DetailForRestaurantSuccess(
      {Key key, @required this.queueModel, @required this.uidQueue})
      : super(key: key);

  @override
  _DetailForRestaurantSuccessState createState() =>
      _DetailForRestaurantSuccessState();
}

class _DetailForRestaurantSuccessState
    extends State<DetailForRestaurantSuccess> {
  QueueModel queueModel;
  String uidQueue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queueModel = widget.queueModel;
    uidQueue = widget.uidQueue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail For Rest Success'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: Colors.redAccent[500],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          child: ClipOval(
                            child: Image.network(queueModel.urlImageUser),
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text('คุณ ${queueModel.nameUser}'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.21,
                          // color: Colors.green,
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'สำเร็จ',
                                style: TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  divider(),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Column(
                          children: [
                            Column(
                              children: [
                                Text(queueModel.tableType),
                                Text('ประเภทโต๊ะ'),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 10),
                              child: Column(
                                children: [
                                  Text(changeDateToString(queueModel.time)),
                                  Text('วันที่จอง'),
                                ],
                              ),
                            ),
                          ],
                        )),
                        divider(),
                        divider(),
                        Container(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(queueModel.peopleAmount),
                                  Text('จำนวนคน'),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15, bottom: 10),
                                child: Column(
                                  children: [
                                    Text(changeTimeToString(queueModel.time)),
                                    Text('เวลาที่จอง'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String changeTimeToString(Timestamp time) {
    DateFormat timeFormat = new DateFormat.Hms();
    String timeStr = timeFormat.format(time.toDate());
    return timeStr;
  }

  String changeDateToString(Timestamp time) {
    DateFormat dateFormat = new DateFormat.yMd();
    String dateStr = dateFormat.format(time.toDate());
    return dateStr;
  }

  Divider divider() {
    return Divider(
      height: 15,
      thickness: 1.5,
      indent: 15,
      endIndent: 15,
      color: Colors.black12,
    );
  }
}
