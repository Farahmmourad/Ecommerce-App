import 'package:flutter/cupertino.dart';

class Review {
  String photoUrl;
  String name;
  String review;
  double rating;

  Review({@required this.photoUrl, @required this.name, @required this.review, @required this.rating});

  factory Review.fromJson(Map<dynamic, dynamic> json) {
    return Review(photoUrl: json['photo_url'], name: json['name'], review: json['review'], rating: json['rating']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'review': review,
      'rating': rating,
      'photoUrl': photoUrl,
    };
  }
}
