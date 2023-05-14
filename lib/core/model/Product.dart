import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:marketky/core/model/ColorWay.dart';
import 'package:marketky/core/model/ProductSize.dart';
import 'package:marketky/core/model/Review.dart';

class Product {
  List<dynamic> image;
  String name;
  int price;
  double rating;
  String description;
  List<ColorWay> colors;
  List<ProductSize> sizes;
  List<Review> reviews;
  String storeName;
  String category;

  Product({
    @required this.image,
    @required this.name,
    @required this.price,
    @required this.rating,
    @required this.description,
    @required this.colors,
    @required this.sizes,
    @required this.reviews,
    @required this.storeName,
    @required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // try {
      return Product(
        image: json['image'],
        name: json['name'],
        price: json['price'],
        rating: json['rating'],
        description: json['description'],
        colors: (json['colors'] as List).map((data) => ColorWay.fromJson(data)).toList(),
        sizes: (json['sizes'] as List).map((data) => ProductSize.fromJson(data)).toList(),
        reviews: (json['reviews'] as List)?.map((data) => Review.fromJson(data))?.toList() ?? [],
        storeName: json['store_name'],
        category: json['category'],
      );
    // }
      // catch (e) {
    //   print(e);
    //   return e;
    // }
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> colorList = colors.map((color) => color.toJson()).toList();
    List<Map<String, dynamic>> sizeList = sizes.map((size) => size.toJson()).toList();
    List<Map<String, dynamic>> reviewList = reviews.map((review) => review.toJson()).toList();
    return {
      'name': name,
      'image': image,
      'rating': rating,
      'description': description,
      'price': price,
      'colors': colorList,
      'sizes': sizeList,
      'reviews': reviewList,
      'storeName': storeName,
      'category': category,
    };
  }
}
