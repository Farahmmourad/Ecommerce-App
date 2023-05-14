import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Category.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/core/services/CategoryService.dart';
import 'package:marketky/core/services/ProductService.dart';
import 'package:marketky/views/screens/empty_cart_page.dart';
import 'package:marketky/views/screens/message_page.dart';
import 'package:marketky/views/screens/search_page.dart';
import 'package:marketky/views/widgets/category_card.dart';
import 'package:marketky/views/widgets/custom_icon_button_widget.dart';
import 'package:marketky/views/widgets/dummy_search_widget_1.dart';
import 'package:marketky/views/widgets/flashsale_countdown_tile.dart';
import 'package:marketky/views/widgets/item_card.dart';

import '../../core/model/Cart.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categoryData = CategoryService.categoryData;
  // List<Product> productData = ProductService.productData;

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('products');
  final DatabaseReference databaseReferenceOrders = FirebaseDatabase.instance.ref().child('orders');
  String email = FirebaseAuth.instance.currentUser.email;
  int totalItemsInCart = 0;
  bool isEmpty = true;
  dynamic cartDataList = [];
  dynamic totalPrice = 0;

  // Timer flashsaleCountdownTimer;
  // Duration flashsaleCountdownDuration = Duration(
  //   hours: 24 - DateTime.now().hour,
  //   minutes: 60 - DateTime.now().minute,
  //   seconds: 60 - DateTime.now().second,
  // );

  // List to hold data
  // List<dynamic> dataList = [];
  dynamic dataList = [];

  @override
  void initState() {
    super.initState();

    // Listen for changes in database reference
    databaseReference.onValue.listen((event) {
      setState(() {
        //change this to List<Map<String, Object>>
        Map<dynamic, dynamic> dataList1 = event.snapshot.value;
        List<Map<String, Object>> mappedList2 = [];
        dataList1.forEach((key, value) {
          Map<String, Object> mappedItem = Map<String, Object>.from(value);
          mappedList2.add(mappedItem);
        });
        // log(dataList1 as String);
        // for (var item in dataList) {
        // List<Map<String, Object>> mappedList = [];
        //   Map<String, Object> mappedItem = Map<String, Object>.from(item);
        //   mappedList.add(mappedItem);
        // }
        // log(mappedList as String);
        List<Product> products = mappedList2.map((data) => Product.fromJson(data)).toList();
        // log(products as String);
        dataList = products;
        // log(dataList1 as String);
      });
    });

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

    // startTimer();
  }


  // void startTimer() {
  //   Timer.periodic(Duration(seconds: 1), (_) {
  //     setCountdown();
  //   });
  // }

  // void setCountdown() {
  //   if (this.mounted) {
  //     setState(() {
  //       final seconds = flashsaleCountdownDuration.inSeconds - 1;
  //
  //       if (seconds < 1) {
  //         flashsaleCountdownTimer.cancel();
  //       } else {
  //         flashsaleCountdownDuration = Duration(seconds: seconds);
  //       }
  //     });
  //   }
  // }

  // @override
  // void dispose() {
  //   if (flashsaleCountdownTimer != null) {
  //     flashsaleCountdownTimer.cancel();
  //   }
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // String seconds = flashsaleCountdownDuration.inSeconds
    //     .remainder(60)
    //     .toString()
    //     .padLeft(2, '0');
    // String minutes = flashsaleCountdownDuration.inMinutes
    //     .remainder(60)
    //     .toString()
    //     .padLeft(2, '0');
    // String hours = flashsaleCountdownDuration.inHours
    //     .remainder(24)
    //     .toString()
    //     .padLeft(2, '0');

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1
          Container(
            height: 190,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 26),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Boutique M.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          height: 150 / 100,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Row(
                        children: [
                          CustomIconButtonWidget(
                            onTap: () {
                              //add condition if card empty then navigate to EmptyCartPage else navigate to CartPage

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
                            icon: SvgPicture.asset(
                              'assets/icons/Bag.svg',
                              color: Colors.white,
                            ),
                          ),
                          CustomIconButtonWidget(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MessagePage()));
                            },
                            value: 2,
                            margin: EdgeInsets.only(left: 16),
                            icon: SvgPicture.asset(
                              'assets/icons/Chat.svg',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                DummySearchWidget1(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Section 2 - category
          Container(
            width: MediaQuery.of(context).size.width,
            color: AppColor.secondary,
            padding: EdgeInsets.only(top: 12, bottom: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View More',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w400),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Category list
                Container(
                  margin: EdgeInsets.only(top: 12),
                  height: 96,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categoryData.length,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 16);
                    },
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        data: categoryData[index],
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Section 3 - banner
          // Container(
          //   height: 106,
          //   padding: EdgeInsets.symmetric(vertical: 16),
          //   child: ListView.separated(
          //     padding: EdgeInsets.symmetric(horizontal: 16),
          //     scrollDirection: Axis.horizontal,
          //     itemCount: 3,
          //     separatorBuilder: (context, index) {
          //       return SizedBox(width: 16);
          //     },
          //     itemBuilder: (context, index) {
          //       return Container(
          //         width: 230,
          //         height: 106,
          //         decoration: BoxDecoration(color: AppColor.primarySoft, borderRadius: BorderRadius.circular(15)),
          //       );
          //     },
          //   ),
          // ),

          // Section 4 - Flash Sale
          // Container(
          //   margin: EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: AppColor.primary,
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: Column(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(16),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               'Flash Sale',
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.w600,
          //                 fontFamily: 'Poppins',
          //               ),
          //             ),
          //             Row(
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 2.0),
          //                   child: FlashsaleCountdownTile(
          //                     digit: hours[0],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 2.0),
          //                   child: FlashsaleCountdownTile(
          //                     digit: hours[1],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 2.0),
          //                   child: Text(
          //                     ':',
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.w600,
          //                       fontFamily: 'Poppins',
          //                     ),
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 2.0),
          //                   child: FlashsaleCountdownTile(
          //                     digit: minutes[0],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 2.0),
          //                   child: FlashsaleCountdownTile(
          //                     digit: minutes[1],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 2.0),
          //                   child: Text(
          //                     ':',
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.w600,
          //                       fontFamily: 'Poppins',
          //                     ),
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 2.0),
          //                   child: FlashsaleCountdownTile(
          //                     digit: seconds[0],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 2.0),
          //                   child: FlashsaleCountdownTile(
          //                     digit: seconds[1],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //       Row(
          //         children: [
          //           Expanded(
          //             child: Container(
          //               height: 310,
          //               child: ListView(
          //                 shrinkWrap: true,
          //                 physics: BouncingScrollPhysics(),
          //                 scrollDirection: Axis.horizontal,
          //                 children: List.generate(
          //                   dataList.length,
          //                   (index) => Padding(
          //                     padding: const EdgeInsets.only(left: 16.0),
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         ItemCard(
          //                           product: dataList[index],
          //                           titleColor: AppColor.primarySoft,
          //                           priceColor: AppColor.accent,
          //                         ),
          //                         Container(
          //                           width: 180,
          //                           child: Row(
          //                             children: [
          //                               Expanded(
          //                                 child: Padding(
          //                                   padding: const EdgeInsets.symmetric(
          //                                       horizontal: 8.0),
          //                                   child: ClipRRect(
          //                                     borderRadius:
          //                                         BorderRadius.circular(10),
          //                                     child: LinearProgressIndicator(
          //                                       minHeight: 10,
          //                                       value: 0.4,
          //                                       color: AppColor.accent,
          //                                       backgroundColor:
          //                                           AppColor.border,
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
          //                               Icon(
          //                                 Icons.local_fire_department,
          //                                 color: AppColor.accent,
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         // Row(
          //                         //   children: [
          //                         //     Expanded(
          //                         //       child: Container(
          //                         //         color: Colors.amber,
          //                         //         height: 10,
          //                         //       ),
          //                         //     ),
          //                         //   ],
          //                         // ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          // Section 5 - product list

          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              'Todays recommendation...',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                dataList.length,
                (index) => ItemCard(
                  product: dataList[index],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
