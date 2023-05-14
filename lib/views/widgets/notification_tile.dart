import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Notification.dart';

import '../screens/order_detail.dart';

class NotificationTile extends StatelessWidget {
  final Function onTap;
  final UserNotification data;

  NotificationTile({
    @required this.onTap,
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderDetail(cart: data.cart)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
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
                            text: '${data.status}',
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
                  Text(
                    '\$${data.totalPrice.toString()}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, fontFamily: 'poppins', color: AppColor.primary),
                  )
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
                    text: '${data.name}',
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
                    text: '${data.address}',
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
                    text: '${data.phoneNumber}',
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
                  '${data.orderedOn}',
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