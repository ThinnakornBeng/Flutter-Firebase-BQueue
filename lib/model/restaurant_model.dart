import 'dart:convert';

class RestaurantModel {
  final String nameRes;
  final String urlImageRes;
  final String address;
  final String token;
  RestaurantModel({
     this.nameRes,
     this.urlImageRes,
     this.address,
     this.token,
  });
 

  Map<String, dynamic> toMap() {
    return {
      'nameRes': nameRes,
      'urlImageRes': urlImageRes,
      'address': address,
      'token': token,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      nameRes: map['nameRes'] ?? '',
      urlImageRes: map['urlImageRes'] ?? '',
      address: map['address'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantModel.fromJson(String source) => RestaurantModel.fromMap(json.decode(source));
}
