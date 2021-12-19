import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String userType;
  final String imageProfile;
  final String token;
  UserModel({
     this.name,
     this.email,
     this.userType,
     this.imageProfile,
     this.token,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'userType': userType,
      'imageProfile': imageProfile,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      userType: map['userType'] ?? '',
      imageProfile: map['imageProfile'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
