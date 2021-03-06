import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/screens/editAddreddRestaurant.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/screens/editNameRestrant.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/navbar/screens/editPhotoRestaurant.dart';
import 'package:flutter_application_beng_queue_app/utility/dialog.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';
import 'package:image_picker/image_picker.dart';

class EditRestaurant extends StatefulWidget {
  @override
  _EditRestaurantState createState() => _EditRestaurantState();
}

class _EditRestaurantState extends State<EditRestaurant> {
  File file;
  double screens;
  String nameRes, address, uidRest, newNameRes, newAddress, newUrlImageRes;
  UserModel userModel;
  RestaurantModel restaurantModel;

  @override
  void initState() {
    super.initState();
    readUidLogin();
  }

  Future<Null> readRestaurantData() async {
    await Firebase.initializeApp().then(
      (value) async {
        FirebaseAuth.instance.authStateChanges().listen(
          (event) async {
            uidRest = event.uid;
          },
        );
      },
    );
  }

  Future<Null> readUidLogin() async {
    await Firebase.initializeApp().then(
      (value) async {
        await FirebaseAuth.instance.authStateChanges().listen(
          (event) async {
            String uid = event.uid;
            // print('Uid = $uid');
            await FirebaseFirestore.instance
                .collection('userTable')
                .doc(uid)
                .snapshots()
                .listen(
              (event) async {
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
                .doc(uid)
                .snapshots()
                .listen(
              (event) {
                setState(() {
                  restaurantModel = RestaurantModel.fromMap(event.data());
                });
                // print(restaurantModel);
                nameRes = restaurantModel.nameRes;
                address = restaurantModel.address;
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screens = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(right: 30),
          child: Center(
            child: Text('Edit Restaurant'),
          ),
        ),
      ),
      body: restaurantModel == null
          ? MyStyle().showProgress()
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    showImage(),
                    // addImage(),
                    // nameRestaurant(),
                    // addressForm(),
                    // saveButton(),
                    editNameRest(), editAddressRest(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget editAddressRest() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(
        left: 10,
        right: 20,
        top: 20,
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditAddressRestaurant(),
            ),
          );
        },
        leading: Icon(
          Icons.fmd_good_sharp,
          size: 30,
          color: Colors.red,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.red,
        ),
        title: Text(
          address,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget editNameRest() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(
        left: 10,
        right: 20,
        top: 20,
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNameRestaurant(),
            ),
          );
        },
        leading: Icon(
          Icons.store_mall_directory_sharp,
          size: 30,
          color: Colors.red,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.red,
        ),
        title: Text(
          nameRes,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget showImage() => GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPhotoRestaurant(),
              ));
        },
        child: Container(
            margin: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            width: 200,
            height: 200,
            child: Card(
              child: file == null
                  ? Image.network(
                      restaurantModel.urlImageRes,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      file,
                      fit: BoxFit.cover,
                    ),
            )),
      );

  Future<Null> callTypeUserDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => SimpleDialog(
            title: ListTile(
              leading: Container(
                  width: 40, height: 40, child: Image.asset('images/logo.png')),
              title: Text('Type User'),
              subtitle: Text('Please choose iamge'),
            ),
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        choooseImage(ImageSource.camera);
                      },
                      leading: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.red,
                      ),
                      title: Text('Camera'),
                    ),
                    ListTile(
                      onTap: () {
                        choooseImage(ImageSource.gallery);
                      },
                      leading: Icon(
                        Icons.photo,
                        color: Colors.red,
                      ),
                      title: Text('Gallery'),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget addImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.photo,
            color: Colors.red,
            size: 30,
          ),
          onPressed: () {
            callTypeUserDialog();
          },
        ),
        // IconButton(
        //   icon: Icon(
        //     Icons.photo_camera,
        //     color: Colors.red,
        //     size: 30,
        //   ),
        //   onPressed: () {},
        // ),
      ],
    );
  }

  Future<Null> choooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().getImage(
        source: imageSource,
        maxHeight: 500,
        maxWidth: 500,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget nameRestaurant() => Container(
        width: screens * 0.8,
        margin: EdgeInsets.only(top: 10),
        child: TextField(
          onChanged: (value) => nameRes = value.trim(),
          decoration: InputDecoration(
            hintText: 'Name Restaurant',
            prefixIcon: Icon(
              Icons.store_mall_directory_sharp,
              color: Colors.red,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
          ),
        ),
      );

  Widget addressForm() => Container(
        width: screens * 0.8,
        margin: EdgeInsets.only(top: 10),
        child: TextField(
          onChanged: (value) => address = value.trim(),
          decoration: InputDecoration(
            hintText: 'Address',
            prefixIcon: Icon(
              Icons.place_rounded,
              color: Colors.red,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
          ),
        ),
      );

  Container saveButton() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 30),
      width: screens * 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          if (newUrlImageRes?.isEmpty ?? true) {
            normalDialog(
                context, 'Please enter your information ian all fields.');
          } else if ((file == null)) {
            normalDialog(context, 'Please your choose images');
          } else {
            upLoadPictureToStoage();
          }
        },
        child: Text(
          'Save',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Future<Null> upLoadPictureToStoage() async {
    Random random = Random();
    int i = random.nextInt(1000000);

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('Restaurant/Restaurant$i.jpg');
    UploadTask uploadTask = reference.putFile(file);

    newUrlImageRes = await (await uploadTask).ref.getDownloadURL();
    print('UrlImage ===>>> $newUrlImageRes');
    upDatePictureToCloudFriestore();
  }

  Future<Null> upDatePictureToCloudFriestore() async {
    Firebase.initializeApp().then(
      (value) async {
        await FirebaseFirestore.instance
            .collection('restaurantTable')
            .doc(uidRest)
            .update(
          {
            'urlImageRes': newUrlImageRes,
          },
        ).then(
          (value) {},
        );
      },
    );
  }
}
