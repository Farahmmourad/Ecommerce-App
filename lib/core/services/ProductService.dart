import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/core/model/Review.dart';

class ProductService {
}

Map<String, dynamic> reviewToMap(Review review) {
  return {
    'name': review.name,
    'rating': review.rating,
    'review': review.review,
  };
}

void addReview(Product product , String rev, double starts) async {
  dynamic dataList = [];
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("products");

  String email = FirebaseAuth.instance.currentUser.email;

  databaseReference.once().then((DatabaseEvent  event) {
    dataList = event.snapshot.value;
    // if (event.snapshot.exists) {
    //   Map<dynamic, dynamic> values = event.snapshot.value;
    //   values.forEach((key, value) {
    //     print(key);
    //   });
    // } else {
    //   print('No data available.1');
    // }
    // Map<dynamic, dynamic>  dataList = event.snapshot.value;
    // if (dataList != null) {
    //
    // for (var item in dataList) {
    //   Map<String, Object> mappedItem = Map<String, Object>.from(item);
    //   mappedList.add(mappedItem);
    // }
    //   List<Map<dynamic, dynamic>> mappedList = [];
    //   for (var item in dataList) {
    //     Map<dynamic, dynamic> mappedItem = Map<dynamic, dynamic>.from(item);
    //     mappedList.add(mappedItem);
    //   }

      // List<Product> products = mappedList.map((data) => Product.fromJson(data)).toList();

    dataList.forEach((key, value) {
        if (value['name'] == product.name && value['category'] == product.category) {

          var listofreviews = value['reviews'];

            Review review = new Review();
            review.name = email;
            review.rating = starts;
            review.review = rev;

            Map<dynamic, dynamic> reviewMap = reviewToMap(review);

          if (listofreviews == null) {
            listofreviews = [reviewMap];
          } else {
            listofreviews = <Map<dynamic, dynamic>>[...listofreviews, reviewMap];
          }

            databaseReference.child(key).update({
              'reviews': listofreviews,
            });
        }
      });
    // }
  });
}

void addReviewFromOrders(String productName , String rev, double starts) async {
  dynamic dataList = [];
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("products");

  String email = FirebaseAuth.instance.currentUser.email;

  databaseReference.once().then((DatabaseEvent  event) {
    dataList = event.snapshot.value;

    dataList.forEach((key, value) {
      if (value['name'] == productName) {

        var listofreviews = value['reviews'];

        Review review = new Review();
        review.name = email;
        review.rating = starts;
        review.review = rev;

        Map<dynamic, dynamic> reviewMap = reviewToMap(review);

        if (listofreviews == null) {
          listofreviews = [reviewMap];
        } else {
          listofreviews = <Map<dynamic, dynamic>>[...listofreviews, reviewMap];
        }

        databaseReference.child(key).update({
          'reviews': listofreviews,
        });
      }
    });
    // }
  });
}
