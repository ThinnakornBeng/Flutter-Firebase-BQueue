import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/screens/user/navbar/screens/addQueueUser.dart';
import 'package:flutter_application_beng_queue_app/utility/dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeUser extends StatefulWidget {
  const QrCodeUser({Key key}) : super(key: key);

  @override
  _QrCodeUserState createState() => _QrCodeUserState();
}

class _QrCodeUserState extends State<QrCodeUser> {
  String scanresult;
  double screens;

  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode resurt;
  QRViewController qrViewController;

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    qrViewController.pauseCamera();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    qrViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screens = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          children: [Container(margin: EdgeInsets.only(top: 15), child: Text('Scan QR CODE',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)),
            Container(margin: EdgeInsets.only(top: 10),
              width: screens*0.95,
              height: screens*1.2, color: Colors.grey,
              // child: QRView(
              //   key: qrKey,
              //   onQRViewCreated: (QRViewController qrViewController) async {
              //     this.qrViewController = qrViewController;
              //     qrViewController.scannedDataStream.listen((event) async {
              //       if (scanresult == null) {
              //         scanresult = event.code;
              //         print('Resurt ===>>> $scanresult');

              //         await Firebase.initializeApp().then((value) async {
              //           FirebaseFirestore.instance
              //               .collection('restaurantTable')
              //               .doc(scanresult)
              //               .get()
              //               .then((value) {
              //             if (value.data() != null) {
              //               print('Valeu ====>>>> ${value.data()}');
              //               RestaurantModel restaurantModel =
              //                   RestaurantModel.fromMap(value.data());
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => AddQueueUser(
              //                     model: restaurantModel,
              //                     uidRest: scanresult,
              //                   ),
              //                 ),
              //               ).then((value) => scanresult == null);
              //             } else {
              //               normalDialog(context, 'No Qr Code');
              //               scanresult = null;
              //             }
              //           });
              //         });
              //       }
              //     });
              //   },
              // ),
            ),
            Divider(),
            // scanresult == null
            //     ? Text(
            //         'No Data',
            //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            //       )
            //     : Text(
            //         scanresult,
            //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            //       ),
            // Center(
            //   child: ElevatedButton(onPressed: () {}, child: Text('Scan')),
            // ),
          ],
        ),
      ),
    );
  }
}
