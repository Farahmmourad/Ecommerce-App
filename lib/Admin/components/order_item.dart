import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      child: Container(width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              margin: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child:  RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Status: ',
                            style: TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                            text: '${order.status}',
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Text(
                  //   '\$${order.totalPrice.toString()}',
                  //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, fontFamily: 'poppins', color: AppColor.primary),
                  // )
                ],
              ),
            ),
            SizedBox(height: 8),
            // Name
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Name: ',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextSpan(
                    text: '${order.name}',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            // Address
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Address : ',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextSpan(
                    text: '${order.address}',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            // Phone number
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Phone Number : ',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextSpan(
                    text: '${order.phoneNumber}',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            // Datetime
            Row(
              children: [
                SvgPicture.asset('assets/icons/Time Circle.svg', color: AppColor.secondary.withOpacity(0.7)),
                SizedBox(width: 6),
                Text(
                  '${order.orderedOn}',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 8),
              child: Divider(
                thickness: 1,
                color: AppColor.secondary.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}