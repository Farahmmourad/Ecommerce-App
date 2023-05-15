import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Notification.dart';
import 'package:marketky/core/services/NotificationService.dart';
import 'package:marketky/views/widgets/main_app_bar_widget.dart';
import 'package:marketky/views/widgets/menu_tile_widget.dart';
import 'package:marketky/views/widgets/notification_tile.dart';

import '../../core/model/Cart.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  String email = FirebaseAuth.instance.currentUser.email;
  final DatabaseReference databaseReferenceOrders = FirebaseDatabase.instance.ref().child('orders');
  dynamic ordersDataList = [];

  Map<String, dynamic> cartToMap(UserNotification cart) {
    return {
      'address': cart.address,
      'name': cart.name,
      'phoneNumber': cart.phoneNumber,
      'status': cart.status,
      'orderedOn': cart.orderedOn,
      'cart': cart.cart,
      'totalPrice': cart.totalPrice,
    };
  }

  @override
  void initState() {
    super.initState();

    databaseReferenceOrders.onValue.listen((event) {

      setState(() {
        ordersDataList = event.snapshot.value;
        dynamic listofproducts = [];
        dynamic listodorders = [];
        double totalPrice = 0;

        if (ordersDataList != null) {
          ordersDataList.forEach((key, value) {
            if (value['email'] == email && value['active'] == false) {

              listofproducts = value['cart'];

              List<Map<String, Object>> mappedList = [];
              for (var item in listofproducts) {
                Map<String, Object> mappedItem = Map<String, Object>.from(item);
                mappedList.add(mappedItem);
              }
              List<Cart> cardsItem = mappedList.map((data) => Cart.fromJson(data)).toList();

              cardsItem.removeWhere((item) => item.count == 0);

              for (var item in cardsItem) {
                totalPrice = totalPrice + item.count * item.price;
              }

              UserNotification x = UserNotification();
              x.name = value['name'];
              x.phoneNumber = value['phoneNumber'];
              x.address = value['address'];
              x.orderedOn = value['orderedOn'];
              x.status = value['status'];
              x.cart = cardsItem;
              x.totalPrice = totalPrice;

              totalPrice = 0;

              Map<dynamic, dynamic> cartMap = cartToMap(x);
              listodorders = <Map<dynamic, dynamic>>[...listodorders, cartMap];
            }
          });
        }

        List<Map<String, Object>> mappedList2 = [];
        for (var item in listodorders) {
          Map<String, Object> mappedItem = Map<String, Object>.from(item);
          mappedList2.add(mappedItem);
        }
        List<UserNotification> ordersItem = mappedList2.map((data) => UserNotification.fromJson(data)).toList();

        ordersDataList = ordersItem;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        cartValue: 2,
        chatValue: 2,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'ORDERS HISTORY',
                    style: TextStyle(color: AppColor.secondary.withOpacity(0.5), letterSpacing: 6 / 100, fontWeight: FontWeight.w600),
                  ),
                ),
                ListView.builder(
                  itemBuilder: (context, index) {
                    return NotificationTile(
                      data: ordersDataList[index],
                      onTap: () {},
                    );
                  },
                  itemCount: ordersDataList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
