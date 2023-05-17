import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Cart.dart';
import 'package:marketky/views/screens/addreview.dart';

class OrderHistoryCart extends StatelessWidget {
  final Cart data;
  final String orderStatus;
  OrderHistoryCart({@required this.data, @required this.orderStatus});
  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border, width: 1),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 70,
            height: 70,
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColor.border,
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                  image: NetworkImage(data.image[0]), fit: BoxFit.cover),
            ),
          ),
          // Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  '${data.name}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'poppins', color: AppColor.secondary),
                ),
                Text(
                  '\Color : ${data.colorName}',
                  style: TextStyle(fontWeight: FontWeight.w300, fontFamily: 'poppins', color: AppColor.secondary),
                ),
                Text(
                  '\Size : ${data.sizeName}',
                  style: TextStyle(fontWeight: FontWeight.w300, fontFamily: 'poppins', color: AppColor.secondary),
                ),
                Text(
                  '\Count : ${data.count}',
                  style: TextStyle(fontWeight: FontWeight.w300, fontFamily: 'poppins', color: AppColor.secondary),
                ),
                Text(
                  '\Price : \$${data.price}',
                  style: TextStyle(fontWeight: FontWeight.w200, fontFamily: 'poppins', color: AppColor.secondary),
                ),
                // Product Price - Increment Decrement Button
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product Price
                      Expanded(
                        child:
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Total : ',
                                style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'poppins', color: AppColor.primary),

                              ),
                              TextSpan(
                                text: '\$${data.price * data.count}',
                                  style: TextStyle(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Increment Decrement Button,
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product Price
                      if(orderStatus == 'delivered' )
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the review page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddReview(productName : data.name),
                            ),
                          );
                        },
                        child: Text('Add Review'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColor.primarySoft, elevation: 0, backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                  // Increment Decrement Button,
                    ],
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
