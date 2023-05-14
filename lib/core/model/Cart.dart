import 'package:flutter/cupertino.dart';

class Cart {
  List<dynamic> image;
  String name;
  int price;
  int count;
  String colorName;
  String sizeName;

  Cart({
    @required this.image,
    @required this.name,
    @required this.price,
    @required this.count,
    @required this.colorName,
    @required this.sizeName,
  });

  factory Cart.fromJson(Map<dynamic, dynamic> json) {
    return Cart(
      image: json['image'],
      name: json['name'],
      price: json['price'],
      count: json['count'],
      colorName: json['colorName'],
      sizeName: json['sizeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'count': count,
      'colorName': colorName,
      'sizeName': sizeName,
    };
  }
}
