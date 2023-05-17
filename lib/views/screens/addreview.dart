
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/views/widgets/dummy_search_widget_1.dart';
import 'package:marketky/views/widgets/item_card.dart';

import '../../constant/app_color.dart';
import '../../core/model/Review.dart';
import '../../core/services/MySearchDelegate.dart';
import '../../core/services/ProductService.dart';

class AddReview extends StatefulWidget {
  final String productName;

  AddReview({@required this.productName});

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<AddReview> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;
  List<dynamic> listOfReview = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String productName = widget.productName;

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1

          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 22, right: 5), // Adjust the top margin value as needed
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8, top: 20), // Set the margin as needed
                      child: Text('Add Review'),
                    ),                  ],
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 6),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            // margin: EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                for (int i = 1; i <= 5; i++)
                  IconButton(
                    icon: Icon(
                      _rating >= i ? Icons.star : Icons.star_border,
                      color: AppColor.primary,
                    ),
                    onPressed: () {
                      // Update the rating variable when a star is pressed
                      setState(() {
                        _rating = i.toDouble();
                      });
                    },
                  ),
              ],
            ),
          ),
          Container(
            // margin: EdgeInsets.only(top: 16),
            margin: EdgeInsets.only(top: 10),
            // width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.primary,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 2,
            ),
          ),
          // Add the "Add Review" button
          Container(
            // color: AppColor.secondary,
            margin: EdgeInsets.only(top: 16, bottom: 10),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 25),
            // margin: EdgeInsets.only(top: 24),
            // width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                String review = _reviewController.text;
                double stars = _rating;

                if (review.isEmpty || _rating == 0) {
                  // Show an error message to the user indicating that all fields are required
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill the required fields for your review')),
                  );
                } else {

                  String email = FirebaseAuth.instance.currentUser.email;

                  Review review2 = new Review();
                  review2.name = email;
                  review2.rating = stars;
                  review2.review = review;

                  listOfReview.add(review2);

                  List<dynamic> newListOfReviews = listOfReview;

                  setState(() {
                    listOfReview = newListOfReviews;
                  });

                  // Call the checkoutCart function and navigate to the OrderSuccessPage
                  addReviewFromOrders(productName, review, stars.toDouble());

                  _reviewController.text = '';
                  _rating = 0;
                }

              },
              child: Text('Add Review'),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColor.primarySoft, elevation: 0, backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}