import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/views/screens/cart_page.dart';

import '../../../core/model/Cart.dart';
import '../../../core/model/Product.dart';
import '../../../core/services/CartService.dart';

class AddToCartModal extends StatefulWidget {
  final Product product;
  AddToCartModal({@required this.product});

  @override
  _AddToCartModalState createState() => _AddToCartModalState();
}

class _AddToCartModalState extends State<AddToCartModal> {
  final fb = FirebaseDatabase.instance;

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    var rng = Random();
    var k = rng.nextInt(10000);
    final ref = fb.ref().child('orders/$k');

    Product product = widget.product;

    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ----------
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 6,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColor.primarySoft,
            ),
          ),
          // Section 1 - increment button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 6),
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0xFF0A0E2F).withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.remove, size: 20, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.primary, shape: CircleBorder(), backgroundColor: AppColor.border,
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '2',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'poppins'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.add, size: 20, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.primary, shape: CircleBorder(), backgroundColor: AppColor.border,
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                ],
              )
            ],
          ),
          // Section 2 - Total and add to cart button
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 18),
            padding: EdgeInsets.all(4),
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColor.primarySoft,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.only(left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('TOTAL', style: TextStyle(fontSize: 10, fontFamily: 'poppins')),
                        Text(product.price.toString(), style: TextStyle(fontSize: 16, fontFamily: 'poppins', fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ElevatedButton(
                    onPressed: () {
                      //add products to cart
                      String email = FirebaseAuth.instance.currentUser.email;

                      addToCart(email,product);

                      dynamic cartDataList = [];
                      dynamic totalPrice = 0;

                      databaseReference.onValue.listen((event) {
                        setState(() {
                          cartDataList = event.snapshot.value;
                          dynamic listofproducts = [];

                          if (cartDataList != null) {
                            cartDataList.forEach((key, value) {
                              if (value['email'] == email && value['active'] == true) {
                                listofproducts = value['cart'];
                              }
                            });
                          }

                          List<Map<String, Object>> mappedList = [];
                          for (var item in listofproducts) {
                            Map<String, Object> mappedItem = Map<String, Object>.from(item);
                            mappedList.add(mappedItem);
                          }
                          List<Cart> cardsItem = mappedList.map((data) => Cart.fromJson(data)).toList();

                          for (var item in cardsItem) {
                            totalPrice = totalPrice + item.count * item.price;
                          }

                          cartDataList = cardsItem;
                        });
                      });
                      Future.delayed(Duration(seconds: 2), () => {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage(cartDataList : cartDataList)))
                      });


                    },
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
