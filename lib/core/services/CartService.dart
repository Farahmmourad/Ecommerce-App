import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:marketky/core/model/Cart.dart';

import '../model/Product.dart';

class CartService {
  static List<Cart> cartData = cartRawData.map((data) => Cart.fromJson(data)).toList();
}

Map<dynamic, dynamic> cartToMap(Cart cart) {
  return {
    'name': cart.name,
    'price': cart.price,
    'image': cart.image,
    'count': cart.count,
  };
}

void addToCart(String email , Product product) async {
  final databaseReference = FirebaseDatabase.instance.ref().child("orders");

  databaseReference.once().then((DatabaseEvent  event) {
    Map<dynamic, dynamic>  orders = event.snapshot.value;
    if (orders != null) {
      orders.forEach((key, value) {
        if (value['email'] == email && value['active'] == true) {
          var listofproducts = value['cart'];

          bool productFound = false;

          listofproducts.forEach((productMap) {
            if (productMap['name'] == product.name) {
              productFound = true;
              productMap['count'] = productMap['count'] + 1;
            }
          });

          if (!productFound) {
            Cart cart = new Cart();
            cart.price = product.price;
            cart.image = product.image;
            cart.name = product.name;
            cart.count = 1;

            Map<dynamic, dynamic> cartMap = cartToMap(cart);
            listofproducts = <Map<dynamic, dynamic>>[...listofproducts, cartMap];

            // listofproducts.add(cartMap);
          }

          databaseReference.child(key).update({
            'cart': listofproducts,
          });
        } else {
          List<dynamic> cartList = [];
          Cart cart = new Cart();
          cart.price = product.price;
          cart.image = product.image;
          cart.name = product.name;
          cart.count = 1;

          Map<String, dynamic> cartMap = cartToMap(cart);

          cartList.add(cartMap);

          databaseReference.push().set({
            'email': email,
            'active': true,
            'cart': cartList,
          });
        }
      }
      );
    } else {
      List<dynamic> cartList = [];
      Cart cart = new Cart();
      cart.price = product.price;
      cart.image = product.image;
      cart.name = product.name;
      cart.count = 1;

      Map<String, dynamic> cartMap = cartToMap(cart);

      cartList.add(cartMap);

      databaseReference.push().set({
        'email': email,
        'active': true,
        'cart': cartList,
      });
    }
  });
}

var cartRawData = [
  {
    'image': [
      'assets/images/nikeblack.jpg',
      'assets/images/nikegrey.jpg',
    ],
    'name': 'Nike Waffle One',
    'price': 1429000,
    'count': 1,
  },
  // 2
  {
    'image': [
      'assets/images/nikegrey.jpg',
      'assets/images/nikeblack.jpg',
    ],
    'name': "Nike Blazer Mid77 Vintage",
    'price': 1429000,
    'count': 1,
  },
  // 3
  {
    'image': [
      'assets/images/nikehoodie.jpg',
      'assets/images/nikehoodie.jpg',
    ],
    'name': "Nike Sportswear Swoosh",
    'price': 849000,
    'count': 1,
  },
];
