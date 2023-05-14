import 'package:flutter/cupertino.dart';
import 'package:marketky/core/model/Cart.dart';

class Order {
  String orderId;
  String name;
  String email;
  String phoneNumber;
  String address;
  bool active;
  String status;
  List<Cart> cart;

  Order({@required this.orderId,@required this.email, @required this.name, @required this.phoneNumber,@required this.active,@required this.address,@required this.status
  ,@required this.cart});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      active: json['active'],
      status: json['status'],
      cart: (json['cart'] as List).map((data) => Cart.fromJson(data)).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> cartList = cart.map((cart) => cart.toJson()).toList();
    return {
      'orderId' : orderId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'active': active,
      'status': status,
      'cart': cartList,
    };
  }
}