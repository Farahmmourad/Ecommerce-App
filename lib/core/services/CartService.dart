import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:marketky/core/model/Cart.dart';

import '../model/Product.dart';

class CartService {
  static List<Cart> cartData = cartRawData.map((data) => Cart.fromJson(data)).toList();
}

Map<String, dynamic> cartToMap(Cart cart) {
  return {
    'name': cart.name,
    'price': cart.price,
    'image': cart.image,
    'count': cart.count,
    'colorName': cart.colorName,
    'sizeName': cart.sizeName,
  };
}

void addToCart(String email , Product product, String colorName, String sizeName) async {
  final databaseReference = FirebaseDatabase.instance.ref().child("orders");

  databaseReference.once().then((DatabaseEvent  event) {
    Map<dynamic, dynamic>  orders = event.snapshot.value;
    bool activeOrder = false;
    if (orders != null) {
      orders.forEach((key, value) {
        if (value['email'] == email && value['active'] == true) {
          activeOrder = true;
          var listofproducts = value['cart'];

          bool productFound = false;

          listofproducts.forEach((productMap) {
            if (productMap['name'] == product.name && productMap['colorName'] == colorName && productMap['sizeName'] == sizeName) {
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
            cart.colorName = colorName;
            cart.sizeName = sizeName;

            Map<dynamic, dynamic> cartMap = cartToMap(cart);
            listofproducts = <Map<dynamic, dynamic>>[...listofproducts, cartMap];

            // listofproducts.add(cartMap);
          }

          databaseReference.child(key).update({
            'cart': listofproducts,
          });
        }
      }
      );
    }

    if(orders == null || !activeOrder) {
      List<dynamic> cartList = [];
      Cart cart = new Cart();
      cart.price = product.price;
      cart.image = product.image;
      cart.name = product.name;
      cart.count = 1;
      cart.colorName = colorName;
      cart.sizeName = sizeName;

      Map<String, dynamic> cartMap = cartToMap(cart);

      cartList.add(cartMap);

      databaseReference.push().set({
        'email': email,
        'active': true,
        'cart': cartList,
        'status': 'pending',
      });
    }
  });
}

void modifyCartPlusMinus(String email , Cart product, bool isPlus) async {
  final databaseReference = FirebaseDatabase.instance.ref().child("orders");

  databaseReference.once().then((DatabaseEvent  event) {
    Map<dynamic, dynamic>  orders = event.snapshot.value;
    if (orders != null) {
      orders.forEach((key, value) {
        if (value['email'] == email && value['active'] == true) {
          var listofproducts = value['cart'];

          listofproducts.forEach((productMap) {
            if (productMap['name'] == product.name && productMap['colorName'] == product.colorName && productMap['sizeName'] == product.sizeName) {
              if(!isPlus){
                if(productMap['count'] > 0){
                  productMap['count'] = productMap['count'] - 1;
                }else{
                  //we want to remove it from the list here
                  // listofproducts = <Map<dynamic, dynamic>> [...listofproducts];
                  // listofproducts.removeWhere((item) => item = productMap);
                  // Map<dynamic, dynamic> cartMap = cartToMap(productMap);
                  // listofproducts = <Map<dynamic, dynamic>>[...listofproducts];
                }
              }
              else{
                productMap['count'] = productMap['count'] + 1;
              }
            }
          });
          databaseReference.child(key).update({
            'cart': listofproducts,
          });

          // var newListOfProducts =  listofproducts.removeWhere((productMap) =>
          // productMap['name'] == product.name &&
          //     productMap['colorName'] == product.colorName &&
          //     productMap['sizeName'] == product.sizeName &&
          //     productMap['count'] == 0
          // );

      }
  });
    }
  });
}

void checkoutCart(String email , String name, String address, String phoneNumber, String todaysDate) async {
  final databaseReference = FirebaseDatabase.instance.ref().child("orders");

  databaseReference.once().then((DatabaseEvent  event) {
    Map<dynamic, dynamic>  orders = event.snapshot.value;

    if (orders != null) {
      orders.forEach((key, value) {
        if (value['email'] == email && value['active'] == true) {
          // var listofproducts = value['cart'];

          databaseReference.child(key).update({
            'active': false,
            'name': name,
            'address': address,
            'phoneNumber': phoneNumber,
            'orderedOn': todaysDate,
          });
        }
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
