import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/views/screens/cart_page.dart';
import 'package:marketky/views/screens/message_page.dart';
import 'package:marketky/views/screens/search_page.dart';
import 'package:marketky/views/widgets/custom_icon_button_widget.dart';
import 'package:marketky/views/widgets/dummy_search_widget2.dart';

import '../../core/model/Cart.dart';
import '../screens/empty_cart_page.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int cartValue;
  final int chatValue;

  MainAppBar({
    @required this.cartValue,
    @required this.chatValue,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  final DatabaseReference databaseReferenceOrders = FirebaseDatabase.instance.ref().child('orders');
  String email = FirebaseAuth.instance.currentUser.email;
  int totalItemsInCart = 0;
  bool isEmpty = true;
  dynamic cartDataList = [];
  dynamic totalPrice = 0;

  @override
  void initState() {
    super.initState();

    databaseReferenceOrders.onValue.listen((event) {
      totalItemsInCart = 0;

      setState(() {
        cartDataList = event.snapshot.value;
        dynamic listofproducts = [];

        if (cartDataList != null) {
          cartDataList.forEach((key, value) {
            if (value['email'] == email && value['active'] == true) {
              listofproducts = value['cart'];
              if(listofproducts != null) {
                isEmpty = false;
              }
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
          totalItemsInCart = totalItemsInCart + item.count;
        }

        cartDataList = cardsItem;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: AppColor.primary,
      elevation: 0,
      title: Row(
        children: [
          DummySearchWidget2(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
          ),
          CustomIconButtonWidget(
            onTap: () {
              //add also conidtion if empty or not go to cart page
              Future.delayed(Duration(seconds: 2), () => {
              if(!isEmpty){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()))
              }else{
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EmptyCartPage()))
              }
              });

            },
            value: totalItemsInCart,
            margin: EdgeInsets.only(left: 16),
            icon: SvgPicture.asset(
              'assets/icons/Bag.svg',
              color: Colors.white,
            ),
          ),
        ],
      ), systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
