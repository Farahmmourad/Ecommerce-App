import 'package:flutter/cupertino.dart';

class Category {
  String iconUrl;
  String name;
  bool featured;
  Category({
    @required this.name,
    @required this.iconUrl,
    @required this.featured,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      featured: json['featured'],
      iconUrl: json['iconUrl'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconUrl': iconUrl,
      'featured': featured,
    };
  }
}
