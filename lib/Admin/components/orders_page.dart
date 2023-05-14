import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketky/core/model/Order.dart';

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
        Order order = Order.fromJson(Map<String, dynamic>.from(data));
        orders.add(order);
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
        children: [
          SizedBox(height: 20),
          Text('Orders'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                orderList.length,
                    (index) =>OrderItem(
                  order: orderList[index],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}