
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marketky/core/model/Product.dart';
import 'package:marketky/views/widgets/dummy_search_widget_1.dart';
import 'package:marketky/views/widgets/item_card.dart';

import '../../core/services/MySearchDelegate.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('users');
  final DatabaseReference databaseReferenceOrders = FirebaseDatabase.instance.ref().child('orders');
  String email = FirebaseAuth.instance.currentUser.email;
  int totalItemsInCart = 0;
  bool isEmpty = true;
  dynamic cartDataList = [];
  dynamic totalPrice = 0;
  MySearchDelegate _searchDelegate;

  dynamic dataList = [];

  @override
  void initState() {
    super.initState();

    databaseReference.onValue.listen((event) {
      setState(() {
        Map<dynamic, dynamic> dataList1 = event.snapshot.value;
        List<Map<String, Object>> mappedList2 = [];
        dataList1.forEach((key, value) {
          if (value['email'] == email) {
                  value['wishlist'].forEach((key1,value1){
                    Map<String, Object> mappedItem = Map<String, Object>.from(value1);
                    mappedList2.add(mappedItem);
                  });
          }
        });
        List<Product> products = mappedList2.map((data) => Product.fromJson(data)).toList();
        dataList = products;
        _searchDelegate = MySearchDelegate();
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
            height: 100,
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
                    Expanded(
                      child: DummySearchWidget1(
                        onTap: () async {
                          final result = await showSearch(
                            context: context,
                            delegate: _searchDelegate,
                          );
                          print(result);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Section 5 - product list

          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              'Your Wish List',
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