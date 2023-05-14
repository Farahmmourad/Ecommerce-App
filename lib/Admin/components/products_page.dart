import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketky/Admin/components/add_page.dart';
import 'package:marketky/Admin/components/product_item.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/ColorWay.dart';
import 'package:marketky/core/model/ProductSize.dart';

import '../../core/model/Product.dart';
import '../../core/model/Review.dart';
import '../../views/widgets/item_card.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('products');

  List<Product> productList = [];

  @override
  void initState() {
    super.initState();

    // Listen for changes in database reference
    databaseReference.onValue.listen((event) {
      Map<dynamic, dynamic> dataMap = event.snapshot.value;

      if (dataMap == null) {
        productList = [];
        return;
      }

      List<dynamic> dataList = dataMap.values.toList();
      List<Product> products = [];
      for (var data in dataList) {
        Product product = Product.fromJson(Map<String, dynamic>.from(data));
        products.add(product);
      }

      setState(() {
        productList = products;
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 20),
          Text('Products'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                productList.length,
                    (index) => ProductItem(
                  product: productList[index],
                      index: index,
                      Listproduct: productList,
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddPage()));

              },
              child: Text('Add Product'),
              style: ElevatedButton.styleFrom(
                primary: AppColor.primary, // Change the color here
              ),
            ),
          ),
        ],
      ),
    );
  }
  }
