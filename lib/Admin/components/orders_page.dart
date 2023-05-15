import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketky/core/model/Order.dart';

import '../../constant/app_color.dart';
import '../../views/widgets/notification_tile.dart';
import 'order_item.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('orders');

  List<dynamic> orderList = [];

  @override
  void initState() {
    super.initState();

    // Listen for changes in database reference
    databaseReference.onValue.listen((event) {
      Map<dynamic, dynamic> dataMap = event.snapshot.value;

      if (dataMap == null) {
        orderList = [];
        return;
      }

      List<dynamic> dataList = dataMap.values.toList();
      List<Order> orders = [];
      for (var data in dataList) {
        if(data['active']== false){
          Order order = Order.fromJson(Map<String, dynamic>.from(data));
          orders.add(order);
        }

      }

      setState(() {
        orderList = orders;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    return OrderItem(
                      order: orderList[index],
                    );
                  },
                  itemCount: orderList.length,
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