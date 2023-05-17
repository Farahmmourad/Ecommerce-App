import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Category.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/core/services/CategoryService.dart';
import 'package:marketky/views/screens/empty_cart_page.dart';
import 'package:marketky/views/widgets/category_card.dart';
import 'package:marketky/views/widgets/custom_icon_button_widget.dart';
import 'package:marketky/views/widgets/dummy_search_widget_1.dart';
import 'package:marketky/views/widgets/item_card.dart';

import '../../core/model/Cart.dart';
import '../../core/services/MySearchDelegate.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('products');
  final DatabaseReference databaseCategoryReference = FirebaseDatabase.instance.ref().child('categories');
  final DatabaseReference databaseReferenceOrders = FirebaseDatabase.instance.ref().child('orders');
  String email = FirebaseAuth.instance.currentUser.email;
  int totalItemsInCart = 0;
  bool isEmpty = true;
  dynamic cartDataList = [];
  dynamic totalPrice = 0;
  MySearchDelegate _searchDelegate;
  List<Category> categoryList = [];
  dynamic dataList = [];

  @override
  void initState() {
    super.initState();

    databaseReference.onValue.listen((event) {
      setState(() {
        Map<dynamic, dynamic> dataList1 = event.snapshot.value;
        List<Map<String, Object>> mappedList2 = [];
        dataList1.forEach((key, value) {
          Map<String, Object> mappedItem = Map<String, Object>.from(value);
          mappedList2.add(mappedItem);
        });
        List<Product> products = mappedList2.map((data) => Product.fromJson(data)).toList();
        dataList = products;
        _searchDelegate = MySearchDelegate(items: products);
      });

    });


    databaseCategoryReference.onValue.listen((event) {
      Map<dynamic, dynamic> dataMap = event.snapshot.value;

      if (dataMap == null) {
        categoryList = [];
        return;
      }

      List<dynamic> dataList = dataMap.values.toList();
      List<Category> categories = [];
      for (var data in dataList) {
        Category category = Category.fromJson(Map<String, dynamic>.from(data));
        categories.add(category);
      }

      setState(() {
        categoryList = categories;
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
  }


  String query = '';
  dynamic get filteredItems {
    if (query.isEmpty || query == "all") {
      return dataList;
    }

    return dataList.where((Product item) => item.category.toLowerCase()==query.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {


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
                        ],
                      ),
                    ],
                  ),
                ),
                DummySearchWidget1(
                  onTap: () async {
                    final result = await showSearch(
                      context: context,
                      delegate: _searchDelegate,
                    );
                    print(result);
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
                    ],
                  ),
                ),
                // Category list
                Container(
                  margin: EdgeInsets.only(top: 12),
                  height: 96,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categoryList.length,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 16);
                    },
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        data: categoryList[index],
                        onTap: () {
                          setState(() {
                            query = categoryList[index].name;
                            for(Category category in categoryList){
                              category.featured = false;
                            }
                            categoryList[index].featured = true;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

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
                filteredItems.length,
                (index) => ItemCard(
                  product: filteredItems[index],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
