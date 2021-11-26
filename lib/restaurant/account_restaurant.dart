import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/model/restaurant_model.dart';
import 'package:flutter_application_beng_queue_app/model/user_model.dart';
import 'package:flutter_application_beng_queue_app/restaurant/navbar/screens/edit_restaurant.dart';
import 'package:flutter_application_beng_queue_app/screens/authentication.dart';
import 'package:flutter_application_beng_queue_app/user/navbar/screens/editNameAndLastnameUser.dart';
import 'package:flutter_application_beng_queue_app/user/navbar/screens/editPasswordUser.dart';
import 'package:flutter_application_beng_queue_app/user/navbar/screens/editPhotoProfileUser.dart';
import 'package:flutter_application_beng_queue_app/utility/dialog.dart';
import 'package:flutter_application_beng_queue_app/utility/my_style.dart';
import 'package:image_picker/image_picker.dart';

class AccountRestaurant extends StatefulWidget {
  @override
  _AccountRestaurantState createState() => _AccountRestaurantState();
}

class _AccountRestaurantState extends State<AccountRestaurant> {
  File file;
  String imageUsser, email, password, nameLogin, lastName, imageProfile;
  UserModel userModel;
  RestaurantModel restaurantModel;

  @override
  void initState() {
    super.initState();
    readUidLogin();
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
                nameLogin = userModel.name;
                imageUsser = userModel.imageProfile;
                password = userModel.password;
                email = userModel.email;
              },
            );
            await FirebaseFirestore.instance
                .collection('restaurantTable')
                .doc(uid)
                .snapshots()
                .listen(
              (event) {
                setState(() {
                  restaurantModel = RestaurantModel.fromMap(
                    event.data(),
                  );
                  // print(restaurantModel);
                });
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
      body: userModel == null
          ? MyStyle().showProgress()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50, right: 15),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                          iconSize: 40,
                          color: Colors.red,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 100),
                          child: Text(
                            'Profile',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  showImage(),
                  editName(),
                  showEmailUser(),
                  editPassword(),
                  editRestaurant(),
                  showTextAboutTheApplication(),
                  signOut(),
                ],
              ),
            ),
    );
  }

  Widget signOut() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(left: 30, right: 40),
      child: ListTile(
        onTap: () async {
          await Firebase.initializeApp().then((value) async {
            await FirebaseAuth.instance
                .signOut()
                .then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Authentication(),
                    ),
                    (route) => false));
          });
        },
        trailing: Icon(
          Icons.exit_to_app_outlined,
          color: Colors.black,
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget showTextAboutTheApplication() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(left: 30, right: 40),
      child: ListTile(
        onTap: () {
          normalDialog(context, 'Version 1.0.0');
        },
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.black,
        ),
        title: Text(
          'About the application',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget editPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(left: 30, right: 40),
      child: ListTile(
        onTap: () {
          if (password == null) {
            normalDialog(
                context, "Can't change password due to login via google.");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPasswordUser(),
              ),
            );
          }
        },
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.black,
        ),
        title: Text(
          'Password : *********',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget showEmailUser() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(left: 30, right: 40),
      child: ListTile(
        onTap: () {
          normalDialog(context, email);
        },
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.black,
        ),
        title: Text(
          'Email : $email',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget editName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(left: 30, right: 40),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNameAndLastnameUser(),
            ),
          );
        },
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.black,
        ),
        title: Container(
          child: Text(
            'Name : $nameLogin',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget imageButton() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: IconButton(
        icon: userModel == null
            ? Image.asset(
                'images/logo.png',
                fit: BoxFit.cover,
              )
            : Image.network(userModel.imageProfile),
        iconSize: 70,
        onPressed: () {
          chooseImage(ImageSource.gallery);
        },
      ),
    );
  }

  Widget showImage() {
    return Container(
      width: 150,
      height: 150,
      child: userModel.imageProfile == null
          ? Card(
              shadowColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPhotoProfileUser(),
                  ),
                );
              },
              child: Card(
                shadowColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    userModel.imageProfile,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().getImage(
        source: imageSource,
        maxHeight: 500.0,
        maxWidth: 500.0,
      );
      setState(
        () {
          file = File(object.path);
        },
      );
    } catch (e) {}
  }

  Widget showName() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            userModel.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget editRestaurant() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 40),
      child: ListTile(
        onTap: () => restaurantModel == null
            ? normalDialog(context, "You don't have restaurant data")
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRestaurant(),
                ),
              ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.black,
        ),
        title: Text(
          'EditReataurantData',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
