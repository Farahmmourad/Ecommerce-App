import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/views/screens/image_viewer.dart';
import 'package:marketky/views/screens/reviews_page.dart';
import 'package:marketky/views/widgets/custom_app_bar.dart';
import 'package:marketky/views/widgets/modals/add_to_cart_modal.dart';
import 'package:marketky/views/widgets/rating_tag.dart';
import 'package:marketky/views/widgets/review_tile.dart';
import 'package:marketky/views/widgets/selectable_circle_color.dart';
import 'package:marketky/views/widgets/selectable_circle_size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/model/Review.dart';
import '../../core/services/ProductService.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  ProductDetail({@required this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  PageController productImageSlider = PageController();

  int _selectedIndex = 0;
  String email = FirebaseAuth.instance.currentUser.email;
  List<dynamic> listOfReview = [];

// Define a TextEditingController for the review text field
  final TextEditingController _reviewController = TextEditingController();

// Define a variable to store the number of stars the user chose
  double _rating = 0;

  _change(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndexSize = 0;

  _changeSize(index) {
    setState(() {
      _selectedIndexSize = index;
    });
  }

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('users');
  List<dynamic> userList = [];

  void addtoWishlist(Product product) async {

    databaseReference.once().then((DatabaseEvent event) async {
      Map<dynamic, dynamic> dataMap = event.snapshot.value;

      if (dataMap == null) {
        userList = [];
        return;
      }

      dataMap.forEach((key, value) async {
        if (value['email'] == email) {
          await databaseReference.child(key).child('wishlist').push().set(product.toJson());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to your wish list')),
          );
        }
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    Product product = widget.product;

    setState(() {
      listOfReview = product.reviews;
    });

    getAverageRating() {
        double average = 0.0;
        for (var i = 0; i < product.reviews.length; i++) {
          average += product.reviews[i].rating;
        }
        double calcualtedAverage = average / product.reviews.length;
        double truncatedNumber = double.parse(
            calcualtedAverage.toStringAsFixed(1));
        return truncatedNumber;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColor.border, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return AddToCartModal(product: product, color : product.colors[_selectedIndex], size : product.sizes[_selectedIndexSize]);
                      },
                    );
                  },
                  child: Text(
                    'Add To Cart',
                    style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - appbar & product image
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // product image
              GestureDetector(
                // onTap: () {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => ImageViewer(imageUrl: product.image),
                //     ),
                //   );
                // },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 310,
                  color: Colors.white,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    controller: productImageSlider,
                    children: List.generate(
                      product.image.length,
                      (index) => Image.network(
                        product.image[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ),
                ),
              ),
              // appbar
              CustomAppBar(
                title: '${product.name}',
                leftIcon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
                rightIcon: SvgPicture.asset(
                  'assets/icons/Bookmark.svg',
                  color: Colors.black.withOpacity(0.5),
                ),
                leftOnTap: () {
                  Navigator.of(context).pop();
                },
                rightOnTap: () {
                  addtoWishlist(product);
                },
              ),
              // indicator
              Positioned(
                bottom: 16,
                child: SmoothPageIndicator(
                  controller: productImageSlider,
                  count: product.image.length,
                  effect: ExpandingDotsEffect(
                    dotColor: AppColor.primary.withOpacity(0.2),
                    activeDotColor: AppColor.primary.withOpacity(0.2),
                    dotHeight: 8,
                  ),
                ),
              ),
            ],
          ),
          // Section 2 - product info
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'poppins', color: AppColor.secondary),
                        ),
                      ),
                      if (product.reviews.length != 0)
                        RatingTag(
                          margin: EdgeInsets.only(left: 10),
                          //change this later to average of all reviews
                          value: getAverageRating(),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 14),
                  child: Text(
                    '\$${product.price}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'poppins', color: AppColor.primary),
                  ),
                ),
                Text(
                  'Bringing a new look to the Waffle sneaker family, the Nike Waffle One balances everything you love about heritage Nike running with fresh innovations.',
                  style: TextStyle(color: AppColor.secondary.withOpacity(0.7), height: 150 / 100),
                ),
              ],
            ),
          ),
          // Section 3 - Color Picker
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Color',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'poppins',
                  ),
                ),
                SelectableCircleColor(
                  colorWay: product.colors,
                  margin: EdgeInsets.only(top: 12),
                  change: _change,
                ),
              ],
            ),
          ),

          // Section 4 - Size Picker
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Size',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'poppins',
                  ),
                ),
                SelectableCircleSize(
                  productSize: product.sizes,
                  margin: EdgeInsets.only(top: 12),
                  changeSize : _changeSize,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            // margin: EdgeInsets.only(top: 8),
            child: Divider(
              thickness: 1,
              color: AppColor.secondary.withOpacity(0.2),
            ),
          ),
          //Add review section
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
          // Add the star rating section

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
                  addReview(product, review, stars.toDouble());

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

          // Section 5 - Reviews
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpansionTile(
                  initiallyExpanded: true,
                  childrenPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  title: Text(
                    'Reviews',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'poppins',
                    ),
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ReviewTile(review: listOfReview[index]),
                      separatorBuilder: (context, index) => SizedBox(height: 16),
                      itemCount: listOfReview.length,
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 52, top: 12, bottom: 6),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.of(context).push(
                    //         MaterialPageRoute(
                    //           builder: (context) => ReviewsPage(
                    //             reviews: product.reviews,
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     child: Text(
                    //       'See More Reviews',
                    //       style: TextStyle(color: AppColor.secondary, fontWeight: FontWeight.w600),
                    //     ),
                    //     style: ElevatedButton.styleFrom(
                    //       foregroundColor: AppColor.primary, elevation: 0, backgroundColor: AppColor.primarySoft,
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
