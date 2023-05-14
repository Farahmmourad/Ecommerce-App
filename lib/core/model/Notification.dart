import 'package:flutter/cupertino.dart';

import 'Cart.dart';

class UserNotification {
  String address;
  String name;
  String phoneNumber;
  String status;
  String orderedOn;
  double totalPrice;
  List<Cart> cart;


  UserNotification({
    @required this.address,
    @required this.name,
    @required this.phoneNumber,
    @required this.status,
    @required this.orderedOn,
    @required this.cart,
    @required this.totalPrice,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      address: json['address'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      status: json['status'],
      orderedOn: json['orderedOn'],
      totalPrice: json['totalPrice'],
      cart: json['cart'],
    );
  }
}
