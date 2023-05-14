import 'package:flutter/cupertino.dart';

class ProductSize {
  String size;
  String name;

  ProductSize({@required this.size, @required this.name});

  factory ProductSize.fromJson(Map<dynamic, dynamic> json) {
    return ProductSize(
      name: json['name'],
      size: json['size'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'size': size,
    };
  }
}
