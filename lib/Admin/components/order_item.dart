import 'package:flutter/material.dart';
import 'package:marketky/Admin/components/edit_product.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Order.dart';

import 'order_detail.dart';

class OrderItem extends StatelessWidget {
  final Order order;
  final Color titleColor;
  final Color priceColor;

  OrderItem({
    @required this.order,
    this.titleColor = Colors.black,
    this.priceColor = AppColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailOrder(order: order)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // item details
            Container(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.name}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2, bottom: 8),
                    child: Text(
                      '${order.status}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: priceColor,
                      ),
                    ),
                  ),
                  Text(
                    '${order.address}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}