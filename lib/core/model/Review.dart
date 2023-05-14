import 'package:flutter/cupertino.dart';

class Review {
  String name;
  String review;
  dynamic rating;

  Review({@required this.name, @required this.review, @required this.rating});

  factory Review.fromJson(Map<dynamic, dynamic> json) {
    return Review(name: json['name'], review: json['review'], rating: json['rating']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'review': review,
      'rating': rating,
    };
  }
}
