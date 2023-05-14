import 'package:flutter/cupertino.dart';

class ColorWay {
  String name;
  String color;

  ColorWay({@required this.name, @required this.color});

  factory ColorWay.fromJson(Map<dynamic, dynamic> json) {
    return ColorWay(name: json['name'], color: json['color']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
    };
  }
}
